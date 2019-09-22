FROM alpine:latest

LABEL "repository"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "homepage"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "maintainer"="youyo <1003ni2@gmail.com>"
LABEL "name"="aws-cdk-github-actions"

RUN apk --update --no-cache add nodejs nodejs-npm python3 jq curl bash
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN ln -sf /usr/bin/pip3 /usr/bin/pip
