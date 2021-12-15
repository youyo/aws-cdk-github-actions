#!/bin/bash

set -u

function parseInputs(){
	# Required inputs
	if [ "${INPUT_CDK_SUBCOMMAND}" == "" ]; then
		echo "Input cdk_subcommand cannot be empty"
		exit 1
	fi
}

function installNpmPackage(){
	package=$1
	scope=$2
	echo "Install $package with scope $scope"

	if [ "${INPUT_DEBUG_LOG}" == "true" ] && [ "$scope" == "local" ]; then
		npm install $package
	elif [ "${INPUT_DEBUG_LOG}" == "true" ] && [ "$scope" == "global" ]; then
		sudo npm install -g $package
	elif [ "$scope" == "local" ]; then
		npm install $package --log-level=error --no-fund --no-audit $package >/dev/null 2>&1
	else
		sudo npm install -g --log-level=error --no-fund --no-audit $package >/dev/null 2>&1
	fi

	if [ "${?}" -ne 0 ]; then
		echo "Failed to install $package"
	else
		echo "Successful install $package"
	fi
}

function installAwsCdk(){
	echo "Install aws-cdk ${INPUT_CDK_VERSION}"
	if [ "${INPUT_CDK_VERSION}" == "latest" ]; then
	  installNpmPackage aws-cdk global
	else
		installNpmPackage aws-cdk@${INPUT_CDK_VERSION} global
	fi
}

function installPipRequirements(){
	if [ -e "requirements.txt" ]; then
		echo "Install requirements.txt"
		if [ "${INPUT_DEBUG_LOG}" == "true" ]; then
			pip install -r requirements.txt
		else
			pip install -r requirements.txt >/dev/null 2>&1
		fi

		if [ "${?}" -ne 0 ]; then
			echo "Failed to install requirements.txt"
		else
			echo "Successful install requirements.txt"
		fi
	fi
}

function runCdk(){
	echo "Run cdk ${INPUT_CDK_SUBCOMMAND} ${*} \"${INPUT_CDK_STACK}\""
	set -o pipefail
	cdk ${INPUT_CDK_SUBCOMMAND} ${*} "${INPUT_CDK_STACK}" 2>&1 | tee output.log
	exitCode=${?}
	set +o pipefail
	echo ::set-output name=status_code::${exitCode}
	output=$(cat output.log)

	commentStatus="Failed"
	if [ "${exitCode}" == "0" ]; then
		commentStatus="Success"
	elif [ "${exitCode}" != "0" ]; then
		echo "CDK subcommand ${INPUT_CDK_SUBCOMMAND} for stack ${INPUT_CDK_STACK} has failed. See above console output for more details."
		exit 1
	fi

	if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${INPUT_ACTIONS_COMMENT}" == "true" ]; then
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
	installNpmPackage typescript local
	installAwsCdk
	installPipRequirements
	runCdk ${INPUT_CDK_ARGS}
}

main
