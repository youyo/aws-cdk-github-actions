FROM alpine:latest

LABEL "com.github.actions.name"="cdk diff"
LABEL "com.github.actions.description"="GitHub Action for AWS CDK. Run `cdk diff`"
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="purple"
LABEL "repository"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "homepage"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "maintainer"="youyo <1003ni2@gmail.com>"
LABEL "name"="aws-cdk-github-actions"

RUN apk --update --no-cache add nodejs nodejs-npm python3 jq curl bash
RUN npm install -g aws-cdk
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
