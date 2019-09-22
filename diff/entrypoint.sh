#!/bin/sh

set -u

# wrap takes some output and wraps it in a collapsible markdown section if it's over $WRAP_LINES long.
wrap() {
	if [[ $(echo "$1" | wc -l) -gt ${WRAP_LINES:-20} ]]; then
		echo "
<details><summary>Show Output</summary>
\`\`\`diff
$1
\`\`\`
</details>
"
	else
		echo "
\`\`\`diff
$1
\`\`\`
"
	fi
}

if [ -e requirements.txt ]; then
	pip install -r requirements.txt
fi

OUTPUT="$(sh -c "cdk diff" 2>&1 ; true)"
echo "${OUTPUT}"

COMMENT="#### \`cdk diff\`
$(wrap "$OUTPUT")

*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*"

PAYLOAD="$(echo '{}' | jq --arg body "${COMMENT}" '.body = $body')"
COMMENTS_URL="$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)"
curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${PAYLOAD}" "${COMMENTS_URL}" > /dev/null
