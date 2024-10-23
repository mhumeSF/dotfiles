# Cargo watch quiet clear (user need to add the -x)
alias cw="cargo watch -q -c"

# Cargo watch run
alias cwr="cargo watch -q -c -w src/ -x 'run -q'"

# cargo watch example zsh/back function
# usage `cwe xp_file_name`
function cwe() {
  cargo watch -q -c -x "run -q --example '$1'"
}

# cargo watch test zsh/bash function
# usage `cwt test_my_fn`
function cwt() {
  cargo watch -q -c -x "test '$1' -- --nocapture"
}

# Cargo watch install
function cwi() {
  cargo watch -x "install --path ."
}
