lv() {
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
      echo "Usage: lv {up|down|reset} [name] [cpus] [memory]"
      echo "  lv up          - create/reset 'local' VM"
      echo "  lv down        - stop and delete 'local' VM"
      echo "  lv reset       - alias for 'up' (recreate VM)"
      echo "  lv up myvm 4 8 - create 'myvm' with 4 CPUs and 8GB RAM"
      return 1
      ;;
  esac
}
