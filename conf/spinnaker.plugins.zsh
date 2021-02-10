# alias haloss='docker run --name spinnaker --rm \
#   -v /Users/mhume/spinnaker-system/.hal:/home/spinnaker/.hal \
#   -v /Users/mhume/spinnaker-system/.secret:/home/spinnaker/.secret \
#   -v /Users/mhume/spinnaker-system/resources:/home/spinnaker/resources \
#   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
#   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
#   -e AWS_REGION=us-west-2 \
#   -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
#   -e AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
#   -it gcr.io/spinnaker-marketplace/halyard:1.32.0'
#
# alias hal='docker run -u 0 --name armory-halyard --rm \
#   -v /Users/mhume/spinnaker-system/.hal:/home/spinnaker/.hal \
#   -v /Users/mhume/spinnaker-system/.secret:/home/spinnaker/.secret \
#   -v /Users/mhume/spinnaker-system/resources:/home/spinnaker/resources \
#   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
#   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
#   -e AWS_REGION=us-west-2 \
#   -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
#   -e AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
#   -it docker.io/armory/halyard-armory:1.8.2'
