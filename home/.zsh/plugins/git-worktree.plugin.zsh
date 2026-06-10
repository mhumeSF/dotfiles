# git worktree helpers
# Usage: w <command> [args]
#   w init <repo-url> [dir]   Clone repo as bare repo for worktrees
#   w co [-g] [query]         Fuzzy-select branch, create/switch to worktree
#                             -g: include remote branches (default: local only)
#   w co -b <branch> [base]   Create new branch and worktree
#   w rm [-d] [query]         Remove a worktree (-d also deletes branch)
#   w cleanup [-f]            Remove worktrees with merged branches
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

# w cleanup [-f]
_w_cleanup() {
  local force=""
  [[ "$1" == "-f" ]] && force="--force"

  local main_branch
  main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||') || main_branch="main"

  git fetch origin "$main_branch" --quiet

  local cleaned=0
  while IFS= read -r line; do
    local wt_path branch
    wt_path=$(echo "$line" | awk '{print $1}')
    branch=$(echo "$line" | grep -o '\[.*\]' | tr -d '[]')

    [[ "$line" == *"(bare)"* ]] && continue
    [[ "$branch" == "$main_branch" ]] && continue
    [[ -z "$branch" ]] && continue

    if git merge-base --is-ancestor "$branch" "origin/$main_branch" 2>/dev/null; then
      echo "Removing merged: $wt_path ($branch)"
      git worktree remove $force "$wt_path" && ((cleaned++))
    fi
  done < <(git worktree list)

  if ((cleaned > 0)); then
    git worktree prune
    echo "Cleaned $cleaned worktree(s)"
  else
    echo "No merged worktrees to clean"
  fi
}
