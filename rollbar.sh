#!/bin/bash

function start_deployment() {
  deploy_id="$(curl --request POST --url https://api.rollbar.com/api/1/deploy/ --data '{"access_token": "project_access_token_from_rollbar", "environment": "'"${DEPLOY_ENV}"'", "revision": "'"${TRAVIS_COMMIT}"'", "comment": "Deployment started in '"${DEPLOYENV}"' for '"${APPLICATION_NAME}"'", "status": "started", "local_username": "'"${AUTHOR_NAME}"'"}' | python -c 'import json, sys; obj = json.load(sys.stdin); print obj["data"]["deploy_id"]')"
  echo "$deploy_id" >> ~/deploy_id_from_rollbar
}

function set_deployment_success() {
  curl --request PATCH --url "https://api.rollbar.com/api/1/deploy/${DEPLOY_ID}?access_token=<project_access_token_from_rollbar>" --data '{"status": "succeeded"}'
}

if [ "$1" == "started" ]
then
  start_deployment started
else
  set_deployment_success succeeded
fi
