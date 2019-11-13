#!/bin/bash

set -eu

function parseInputs(){
	# Required inputs
	if [ "${INPUT_CDK_SUBCOMMAND}" == "" ]; then
		echo "Input cdk_subcommand cannot be empty"
		exit 1
	fi
}

function installAwsCdk(){
	echo "Install aws-cdk ${INPUT_CDK_VERSION}"
	if [ "${INPUT_CDK_VERSION}" == "latest" ]; then
		npm install -g aws-cdk
		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		fi
	else
		npm install -g aws-cdk@${INPUT_CDK_VERSION}
		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		fi
	fi
}

function installPipRequirements(){
	if [ -e "requirements.txt" ]; then
		pip install -r requirements.txt
	fi
}

function runCdk(){
	output=$(cdk ${INPUT_CDK_SUBCOMMAND} ${*} 2>&1)
	exitCode=${?}

	commentStatus="Failed"
	if [ "${exitCode}" == "0" || "${exitCode}" == "1" ]; then
		commentStatus="Success"
	fi

	if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${INPUT_ACTIONS_COMMENT}" == "1" ]; then
		commentWrapper="#### \`cdk ${INPUT_CDK_SUBCOMMAND}\` ${commentStatus}
<details><summary>Show Output</summary>

\`\`\`
${output}
\`\`\`

</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${INPUT_WORKING_DIR}\`*"

		payload=$(echo "${commentWrapper}" | jq -R --slurp '{body: .}')
		commentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)

		echo "${payload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${commentsURL}" > /dev/null
	fi
}

function main(){
	parseInputs
	cd ${GITHUB_WORKSPACE}/${INPUT_WORKING_DIR}
	installPipRequirements
	runCdk
}

main
