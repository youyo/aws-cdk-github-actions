FROM youyo/aws-cdk-github-actions:base

LABEL "com.github.actions.name"="AWS-CDK Diff"
LABEL "com.github.actions.description"="GitHub Action for AWS CDK. Run `cdk diff`"
LABEL "com.github.actions.icon"="shuffle"
LABEL "com.github.actions.color"="green"
LABEL "repository"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "homepage"="https://github.com/youyo/aws-cdk-github-actions/diff"
LABEL "maintainer"="youyo <1003ni2@gmail.com>"

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
