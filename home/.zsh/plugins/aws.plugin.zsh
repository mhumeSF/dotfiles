export AWS_SDK_LOAD_CONFIG=1

unset_aws() {
  AWS_VARS=(
    AWS_ROLE_ARN
    AWS_ACCESS_KEY_ID
    AWS_DEFAULT_REGION
    AWS_REGION
    AWS_SECRET_ACCESS_KEY
    AWS_SECURITY_TOKEN
    AWS_SESSION_TOKEN
    AWS_VAULT
    AWS_PROFILE
  )
  for i in ${AWS_VARS[@]}; do unset $i; done
}

assume() {
  unset_aws
  if [[ "$2" == "env" ]]; then
    $($(grep -A 2 $1\] ~/.aws/config | grep credential_process | sed 's/credential_process=//' | sed 's/--org/--environment --no-aws-cache --org/') | perl -pe 's/ && /\n/g' | sed "s/\'//g")
  else
    export AWS_PROFILE=$1
  fi
}

# AWS Profile completer for bash autocompletion
# https://inodes.org/2018/09/21/switching-aws-profiles/
_aws_profile_completer() {
  # Extract profile names from ~/.aws/config
  _commands=$(cat ~/.aws/config | grep '^\[' | sed 's/.$//;s/^.//' | grep -v '*source')
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "${_commands}" -- ${cur}) )

  return 0
}

# Enable autocompletion for the 'assume' function
complete -F _aws_profile_completer assume
