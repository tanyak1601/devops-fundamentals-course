#!/bin/bash

export ENV_CONFIGURATION="production"
SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
CLIENT_APP_PATH="${SCRIPT_DIR}/client"

cd "${CLIENT_APP_PATH}" || exit

npm run lint
lint_status=$?

npm run test
test_status=$?

npm audit
audit_status=$?

echo "Quality report:"

if [ $lint_status -ne 0 ]
then
    echo "Lint errors found ❌"
else 
    echo "No lint errors found ✅"
fi

if [ $test_status -ne 0 ]
then
  echo "Some unit tests failed ❌"
else
  echo "All unit tests passed ✅"
fi

if [ $audit_status -ne 0 ]
then
  echo "Audit failed! Vulnerabilities found ❌"
else
  echo "Audit passed! No vulnerabilities found ✅"
fi