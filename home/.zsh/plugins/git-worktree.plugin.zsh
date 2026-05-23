# git worktree helpers

# wtn: create a new worktree with a new branch (dir name == branch name)
# Usage: wtn <branch> [base]
# base defaults to origin/HEAD
wtn() {
  local branch="${1:?Usage: wtn <branch> [base]}"
  local base="${2:-origin/HEAD}"
  git worktree add "$branch" -b "$branch" "$base"
}

# wto: create a worktree for an existing remote branch
# Usage: wto <branch>
wto() {
  local branch="${1:?Usage: wto <branch>}"
  git worktree add "$branch" "$branch"
}
