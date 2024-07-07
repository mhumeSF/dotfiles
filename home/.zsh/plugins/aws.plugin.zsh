# Enable AWS SDK to use the config file
export AWS_SDK_LOAD_CONFIG=1

# Function to unset all AWS-related environment variables
unset_aws() {
  # List of AWS environment variables to unset
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
  # Unset each variable in the list
  for i in ${AWS_VARS[@]}; do unset $i; done
}

# Function to assume an AWS role or profile
assume() {
  unset_aws  # Clear existing AWS environment variables
  if [[ "$2" == "env" ]]; then
    # If 'env' is specified, use credential_process from ~/.aws/config
    $($(grep -A 2 $1\] ~/.aws/config | grep credential_process | sed 's/credential_process=//' | sed 's/--org/--environment --no-aws-cache --org/') | perl -pe 's/ && /\n/g' | sed "s/\'//g")
  else
    # Otherwise, set AWS_PROFILE
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
  # Generate completion matches
  COMPREPLY=( $(compgen -W "${_commands}" -- ${cur}) )
  return 0
}

# Enable autocompletion for the 'assume' function
complete -F _aws_profile_completer assume
