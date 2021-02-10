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
