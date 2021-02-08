#!/bin/bash
print_in_green() {
  printf "\e[0;32m$1\e[0m"
}

print_success() {
  print_in_green "  [✔] $1\n"
}

print_in_red() {
  printf "\e[0;31m$1\e[0m"
}

print_error() {
  print_in_red "  [✖] $1 $2\n"
}

brew_install() {
  if brew list $1 &>/dev/null; then
    print_success "$1"
  else
    brew install $1
  fi
}

brew_cask_install() {
  if brew list --cask $1 &>/dev/null; then
    print_success "$1"
  else
    brew install --cask $1
  fi
}

cmd_exists() {
  command -v "$1" &>/dev/null
}

print_result() {

  if [ "$1" -eq 0 ]; then
    print_success "$2"
  else
    print_error "$2"
  fi

  return "$1"

}

execute() {

  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

  local exitCode=0
  local cmdsPID=""

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # If the current process is ended,
  # also end all its subprocesses.

  set_trap "EXIT" "kill_all_subprocesses"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Execute commands in background

  eval "$CMDS" \
    &>/dev/null \
    2>"$TMP_FILE" &

  cmdsPID=$!

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Show a spinner if the commands
  # require more time to complete.

  show_spinner "$cmdsPID" "$CMDS" "$MSG"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Wait for the commands to no longer be executing
  # in the background, and then get their exit code.

  wait "$cmdsPID" &>/dev/null
  exitCode=$?

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Print output based on what happened.

  print_result $exitCode "$MSG"

  if [ $exitCode -ne 0 ]; then
    print_error_stream <"$TMP_FILE"
  fi

  rm -rf "$TMP_FILE"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return $exitCode

}

set_trap() {

  trap -p "$1" | grep "$2" &>/dev/null ||
    trap '$2' "$1"

}

show_spinner() {

  local -r FRAMES='/-\|'

  # shellcheck disable=SC2034
  local -r NUMBER_OR_FRAMES=${#FRAMES}

  local -r CMDS="$2"
  local -r MSG="$3"
  local -r PID="$1"

  local i=0
  local frameText=""

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Display spinner while the commands are being executed.

  while kill -0 "$PID" &>/dev/null; do
    frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
    printf "%s" "$frameText"
    sleep 0.2
    printf "\r"
  done

}
