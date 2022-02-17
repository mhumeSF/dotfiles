alias k="kubectl"
alias kc="kubectl-ctx"
alias kn="kubectl-ns"

function kubectl() {
  if ! type __start_kubectl >/dev/null 2>&1; then
    source <(command kubectl completion zsh)
  fi
  command kubectl "$@"
}
# kubectl crew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
