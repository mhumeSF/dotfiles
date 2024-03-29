#!/bin/bash

print_in_color() {
  printf "%b" \
    "$(tput setaf "$2" 2>/dev/null)" \
    "$1" \
    "$(tput sgr0 2>/dev/null)"
}

print_in_green() {
  print_in_color "$1" 2
}

print_in_purple() {
  print_in_color "$1" 5
}

print_in_red() {
  print_in_color "$1" 1
}

print_in_yellow() {
  print_in_color "$1" 3
}

print_success() {
  print_in_green "   [✔] $1\n"
}

print_question() {
  print_in_yellow "   [?] $1"
}

print_warning() {
  print_in_yellow "   [!] $1\n"
}

print_error() {
  print_in_red "  [✖] $1 $2\n"
}

print_result() {

  if [ "$1" -eq 0 ]; then
    print_success "$2"
  else
    print_error "$2"
  fi

  return "$1"

}

brew_install() {

  declare -r ARGUMENTS="$3"
  declare -r FORMULA="$2"
  declare -r FORMULA_READABLE_NAME="$1"
  declare -r TAP_VALUE="$4"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Check if `Homebrew` is installed.

  if ! cmd_exists "brew"; then
    print_error "$FORMULA_READABLE_NAME ('Homebrew' is not installed)"
    return 1
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # If `brew tap` needs to be executed,
  # check if it executed correctly.

  if [ -n "$TAP_VALUE" ]; then
    if ! brew_tap "$TAP_VALUE"; then
      print_error "$FORMULA_READABLE_NAME ('brew tap $TAP_VALUE' failed)"
      return 1
    fi
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Install the specified formula.

  # shellcheck disable=SC2086
  if brew list "$FORMULA" &>/dev/null; then
    print_success "$FORMULA_READABLE_NAME"
  else
    execute \
      "brew install $FORMULA $ARGUMENTS" \
      "$FORMULA_READABLE_NAME"
  fi

}

cmd_exists() {
  command -v "$1" &>/dev/null
}

print_error_stream() {
  while read -r line; do
    print_error "↳ ERROR: $line"
  done
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
