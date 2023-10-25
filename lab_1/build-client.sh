#!/bin/bash

export ENV_CONFIGURATION="production"

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

CLIENT_APP_PATH="${SCRIPT_DIR}/client"
CLIENT_BUILD_DIR="${SCRIPT_DIR}/dist"
clientBuildFile="${SCRIPT_DIR}/dist/client-app.zip"

if [ -e "$clientBuildFile" ]; then
  rm "$clientBuildFile"
  echo "$clientBuildFile was removed."
fi

cd "${CLIENT_APP_PATH}" || exit

npm install

npm run build -- --configuration="$ENV_CONFIGURATION"

mkdir -p "$CLIENT_BUILD_DIR"
zip -r "$clientBuildFile" "$CLIENT_APP_PATH"/dist/app

echo "Client app was built with '$ENV_CONFIGURATION' configuration."