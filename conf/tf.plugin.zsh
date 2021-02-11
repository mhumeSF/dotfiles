autokey() {
  PWD=$(pwd)
  GIT_ROOT=$(git rev-parse --show-toplevel)
  GIT_FOLDER=$(basename $(git rev-parse --show-toplevel))
  export TF_CLI_ARGS_init="-backend-config=\"key=${GIT_FOLDER}${PWD##${GIT_ROOT}}/terraform.tfstate\""
}

tfenv() {
    if [[ $1 == "use" ]]; then
        echo $2 > $HOME/.terraform-version
        command tfenv use $2
    else
        command tfenv "$@"
    fi
}

# alias terraforming='docker run --rm \
#   --name terraforming \
#   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
#   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
#   -e AWS_REGION=us-west-2 \
#   -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
#   -e AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
#   quay.io/dtan4/terraforming:latest \
#   terraforming'

function resolve_tfenv_version() {
  local VERSION_FILE=".terraform-version"

  if [ ! -z $TFENV_TERRAFORM_VERSION];
  then
    VERSION=$TFENV_TERRAFORM_VERSION

  elif [ -f "./$VERSION_FILE" ];
  then
    VERSION=$(cat "./$VERSION_FILE")

  elif [ -f "$(git rev-parse --show-toplevel)/$VERSION_FILE" ];
  then
    VERSION=$(cat "$(git rev-parse --show-toplevel)/$VERSION_FILE");

  elif [ -f "$HOME/$VERSION_FILE" ];
  then
    VERSION=$(cat $HOME/$VERSION_FILE)
  else
    echo "null"
  fi

  echo $VERSION
}
