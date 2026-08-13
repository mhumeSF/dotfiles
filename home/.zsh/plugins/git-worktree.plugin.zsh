# git worktree helpers
# Usage: w <command> [args]
#   w init <repo-url> [dir]   Clone repo as bare repo for worktrees
#   w co [-g] [query]         Fuzzy-select branch, create/switch to worktree
#                             -g: include remote branches (default: local only)
#   w co -b <branch> [base]   Create new branch and worktree
#   w rm [-d] [query]         Remove a worktree (-d also deletes branch)
#   w cleanup [-f] [--closed] [--dry-run]
#                             Remove worktrees AND local branches whose branch
#                             was merged (default). Squash/rebase merges are
#                             detected via the PR state when gh is available.
#                             --closed:  also remove worktrees/branches whose PR
#                                        was closed WITHOUT merging (needs gh)
#                             --dry-run: show what would be removed, change nothing
#                             -f:        force-remove dirty/locked worktrees
#   w list                    List all worktrees

w() {
  local cmd="${1:-}"
  shift 2>/dev/null || true

  case "$cmd" in
    init)
      _w_init "$@"
      ;;
    co)
      _w_checkout "$@"
      ;;
    rm)
      _w_remove "$@"
      ;;
    cleanup)
      _w_cleanup "$@"
      ;;
    list|ls)
      git worktree list "$@"
      ;;
    *)
      echo "Usage: w <command> [args]"
      echo "Commands: init, co, rm, cleanup, list"
      return 1
      ;;
  esac
}

# w init <repo-url> [dir-name]
_w_init() {
  local repo_url="${1:?Usage: w init <repo-url> [dir-name]}"
  local dir_name="${2:-$(basename -s .git "$repo_url")}"

  if [[ -e "$dir_name" ]]; then
    echo "Error: $dir_name already exists" >&2
    return 1
  fi

  mkdir "$dir_name" && cd "$dir_name" || return 1

  git clone --bare "$repo_url" .bare || { cd - >/dev/null; return 1; }

  echo "gitdir: ./.bare" > .git

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch origin

  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

  git worktree add "$default_branch" "$default_branch"

  # `git clone --bare` doesn't set branch tracking, so the default branch has
  # no upstream (git pull would warn "no tracking information"). Set it here.
  git branch --set-upstream-to="origin/$default_branch" "$default_branch"

  echo "Setup complete: $dir_name/$default_branch"
}

# w co [-g] [-b <branch> [base]] [query]
_w_checkout() {
  local include_remote=false

  # Parse flags
  while [[ "$1" == -* ]]; do
    case "$1" in
      -g)
        include_remote=true
        shift
        ;;
      -b)
        shift
        local branch="${1:?Usage: w co -b <branch> [base]}"
        local base="${2:-origin/HEAD}"
        local dir="${branch//\//-}"
        git worktree add "$dir" -b "$branch" "$base"
        return
        ;;
      *)
        break
        ;;
    esac
  done

  local query="$1"
  local branch

  # List branches based on mode
  if $include_remote; then
    # Include remote branches, dedupe by stripping origin/ prefix
    branch=$(
      {
        git for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)'
        git for-each-ref --sort=-committerdate refs/remotes/origin --format='%(refname:short)' | sed 's|^origin/||' | grep -v '^HEAD$'
      } | awk '!seen[$0]++' | fzf --query="$query" --select-1
    ) || return
  else
    # Local branches only
    branch=$(
      git for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)' | fzf --query="$query" --select-1
    ) || return
  fi

  [[ -z "$branch" ]] && return

  # Check if worktree already exists for this branch
  local wt_path
  wt_path=$(git worktree list --porcelain | grep -A2 "^worktree " | grep -B1 "branch refs/heads/$branch$" | head -1 | sed 's/^worktree //')

  if [[ -n "$wt_path" ]]; then
    cd "$wt_path"
  else
    local dir="${branch//\//-}"
    git worktree add "$dir" "$branch" && cd "$dir"
  fi
}

# w rm [-d] [query]
_w_remove() {
  local delete_branch=false
  if [[ "$1" == "-d" ]]; then
    delete_branch=true
    shift
  fi

  local line
  line=$(git worktree list | grep -v '(bare)' | fzf --query="$1" --select-1) || return
  [[ -z "$line" ]] && return

  local wt_path branch
  wt_path=$(echo "$line" | awk '{print $1}')
  branch=$(echo "$line" | grep -o '\[.*\]' | tr -d '[]')

  git worktree remove "$wt_path" || return
  echo "Removed worktree: $wt_path"

  if $delete_branch && [[ -n "$branch" ]]; then
    git branch -d "$branch" 2>/dev/null || git branch -D "$branch"
    echo "Deleted branch: $branch"
  fi
}

# Print why <branch> is safe to clean ("merged" or "closed"); fail if it isn't.
# Squash/rebase merges rewrite SHAs, so when the ancestor check fails we ask
# GitHub about the PR state instead.
_w_merge_reason() {
  local branch="$1" main_branch="$2" have_gh="$3" closed="$4"

  if git merge-base --is-ancestor "$branch" "origin/$main_branch" 2>/dev/null; then
    echo "merged"
    return 0
  fi
  if [[ "$have_gh" == true ]]; then
    if [[ "$(gh pr list --head "$branch" --state merged --json number --jq 'length' 2>/dev/null)" -gt 0 ]]; then
      echo "merged"
      return 0
    fi
    if [[ "$closed" == true && "$(gh pr list --head "$branch" --state closed --json state --jq '[.[] | select(.state == "CLOSED")] | length' 2>/dev/null)" -gt 0 ]]; then
      echo "closed"
      return 0
    fi
  fi
  return 1
}

# w cleanup [-f] [--closed] [--dry-run]
_w_cleanup() {
  local force="" closed=false dry_run=false
  while [[ "$1" == -* ]]; do
    case "$1" in
      -f|--force)   force="--force" ;;
      --closed)     closed=true ;;
      -n|--dry-run) dry_run=true ;;
      *) echo "Unknown flag: $1" >&2; return 1 ;;
    esac
    shift
  done

  local main_branch
  main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||') || main_branch="main"

  git fetch origin "$main_branch" --quiet

  local have_gh=false
  command -v gh >/dev/null 2>&1 && have_gh=true
  if ! $have_gh; then
    echo "Warning: gh not found; only fast-forward/true-merge detection available" >&2
    $closed && echo "Warning: --closed requires gh; ignoring" >&2
  fi

  local cleaned=0
  local wt_path branch reason
  while IFS= read -r line; do
    wt_path=$(echo "$line" | awk '{print $1}')
    branch=$(echo "$line" | grep -o '\[.*\]' | tr -d '[]')

    [[ "$line" == *"(bare)"* ]] && continue
    [[ "$branch" == "$main_branch" ]] && continue
    [[ -z "$branch" ]] && continue

    reason=$(_w_merge_reason "$branch" "$main_branch" "$have_gh" "$closed") || continue

    if $dry_run; then
      echo "[dry-run] would remove $reason: $wt_path ($branch)"
      ((cleaned++))
      continue
    fi

    echo "Removing $reason: $wt_path ($branch)"
    if git worktree remove $force "$wt_path"; then
      git branch -D "$branch" 2>/dev/null && echo "  deleted branch: $branch"
      ((cleaned++))
    fi
  done < <(git worktree list)

  # Second pass: merged/closed local branches that have no worktree (e.g. the
  # worktree was removed by hand, or the branch never had one).
  local wt_branches
  wt_branches=$(git worktree list --porcelain | awk '$1 == "branch" { sub("refs/heads/", "", $2); print $2 }')

  for branch in $(git for-each-ref refs/heads --format='%(refname:short)'); do
    [[ "$branch" == "$main_branch" ]] && continue
    [[ -n "$wt_branches" ]] && grep -qxF "$branch" <<<"$wt_branches" && continue

    reason=$(_w_merge_reason "$branch" "$main_branch" "$have_gh" "$closed") || continue

    if $dry_run; then
      echo "[dry-run] would delete $reason branch: $branch"
      ((cleaned++))
      continue
    fi

    # -D not -d: squash/rebase merges leave commits git considers unmerged
    if git branch -D "$branch" >/dev/null 2>&1; then
      echo "Deleted $reason branch: $branch"
      ((cleaned++))
    fi
  done

  if $dry_run; then
    ((cleaned > 0)) && echo "Dry run: $cleaned item(s) would be cleaned" || echo "Dry run: nothing to clean"
  elif ((cleaned > 0)); then
    git worktree prune
    echo "Cleaned $cleaned item(s)"
  else
    echo "Nothing to clean"
  fi
}
