#! /bin/bash

## Prepare and Upload AWS Lambda function
##
## @author Zvi Avraham <zvi-AT-zadata-DOT-com>
## @copyright 2014 ZADATA Ltd. All Rights Reserved.

set -e

cd `dirname $0`
FUNCTION=`basename \`pwd\``

FUNCTION_ZIP="$FUNCTION.zip"
#FUNCTION_HANDLER="$FUNCTION.handler"
FUNCTION_HANDLER="index.handler"

# NOTE: use your own IAM lambda execution role
#lambda_execution_role_arn="arn:aws:iam::************:role/lambda_exec_role"


MEMORY_SIZE=128
TIMEOUT_SEC=10

echo "FUNCTION = $FUNCTION"
echo "FUNCTION_ZIP = ${FUNCTION_ZIP}"
echo "FUNCTION_HANDLER = ${FUNCTION_HANDLER}"

# TODO: handle recursive CoffeeScript compilation
# TODO: delete old generated .js files
# TODO: maybe use grunt, gulp or brocolli

# TODO: handle case when plain JS - no CoffeeScript
files=(*.coffee)
if [ -e "${files[0]}" ]; then
	coffee -b -c *.coffee
fi

rm -rf node_modules/
npm install

rm -f ${FUNCTION_ZIP}
zip -r ${FUNCTION_ZIP} *.js node_modules @ --exclude=*aws-sdk*

aws lambda upload-function  \
	--function-name "$FUNCTION" \
	--function-zip "${FUNCTION_ZIP}" \
	--role "$lambda_execution_role_arn" \
	--mode event \
	--handler "${FUNCTION_HANDLER}" \
	--memory-size ${MEMORY_SIZE} \
	--timeout ${TIMEOUT_SEC} \
	--runtime nodejs
