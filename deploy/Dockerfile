FROM youyo/aws-cdk-github-actions:base

LABEL "com.github.actions.name"="AWS-CDK Deploy"
LABEL "com.github.actions.description"="GitHub Action for AWS CDK. Run `cdk deploy`"
LABEL "com.github.actions.icon"="rotate-cw"
LABEL "com.github.actions.color"="blue"
LABEL "repository"="https://github.com/youyo/aws-cdk-github-actions"
LABEL "homepage"="https://github.com/youyo/aws-cdk-github-actions/deploy"
LABEL "maintainer"="youyo <1003ni2@gmail.com>"

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
