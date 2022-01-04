#!/bin/bash

set -u

function parseInputs(){
	# Required inputs
	if [ "${INPUT_CDK_SUBCOMMAND}" == "" ]; then
		echo "Input cdk_subcommand cannot be empty"
		exit 1
	fi
}

function installTypescript(){
	npm install -g ts-node
}

function installAwsCdk(){
	echo "Install aws-cdk ${INPUT_CDK_VERSION}"
	if [ "${INPUT_CDK_VERSION}" == "latest" ]; then
		if [ "${INPUT_DEBUG_LOG}" == "true" ]; then
			npm install -g aws-cdk
		else
			npm install -g aws-cdk >/dev/null 2>&1
		fi

		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		else
			echo "Successful install aws-cdk ${INPUT_CDK_VERSION}"
		fi
	else
		if [ "${INPUT_DEBUG_LOG}" == "true" ]; then
			npm install -g aws-cdk@${INPUT_CDK_VERSION}
		else
			npm install -g aws-cdk@${INPUT_CDK_VERSION} >/dev/null 2>&1
		fi

		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		else
			echo "Successful install aws-cdk ${INPUT_CDK_VERSION}"
		fi
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
	cdk ${INPUT_CDK_SUBCOMMAND} ${*} "${INPUT_CDK_STACK}"
	exitCode=${?}
	set +o pipefail
	echo ::set-output name=status_code::${exitCode}

	commentStatus="Failed"
	if [ "${exitCode}" == "0" ]; then
		commentStatus="Success"
	elif [ "${exitCode}" != "0" ]; then
		echo "CDK subcommand ${INPUT_CDK_SUBCOMMAND} for stack ${INPUT_CDK_STACK} has failed. See above console output for more details."
		exit 1
	fi
}

function main(){
        node -v
	parseInputs
	cd ${GITHUB_WORKSPACE}/${INPUT_WORKING_DIR}
	installTypescript
	installAwsCdk
	installPipRequirements
	runCdk ${INPUT_CDK_ARGS}
}

main
