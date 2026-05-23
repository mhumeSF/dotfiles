# lima helper - wraps limactl with custom up/down/reset commands
l() {
  case "$1" in
    up)
      local name="${2:-local}"
      local cpus="${3:-2}"
      local memory="${4:-4}"
      limactl stop "$name" 2>/dev/null
      limactl delete "$name" 2>/dev/null
      limactl create --name "$name" --tty=false template://ubuntu --cpus="$cpus" --memory="$memory" --plain --set='.ssh.loadDotSSHPubKeys=true | .ssh.localPort=60022'
      limactl start "$name"
      ;;
    down)
      local name="${2:-local}"
      limactl stop "$name" 2>/dev/null
      limactl delete "$name" 2>/dev/null
      ;;
    reset)
      local name="${2:-local}"
      local cpus="${3:-2}"
      local memory="${4:-4}"
      limactl stop "$name" 2>/dev/null
      limactl delete "$name" 2>/dev/null
      limactl create --name "$name" --tty=false template://ubuntu --cpus="$cpus" --memory="$memory" --plain --set='.ssh.loadDotSSHPubKeys=true | .ssh.localPort=60022'
      limactl start "$name"
      ;;
    *)
      limactl "$@"
      ;;
  esac
}
