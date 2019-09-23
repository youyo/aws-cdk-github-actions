# GitHub Action for AWS-CDK deploy

AWS-CDK GitHub Actions allow you to run `cdk deploy` on your pull requests and push event to help you review.

## Usage

```yaml
name: cdk deploy

on: pull_request

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: youyo/aws-cdk-github-actions/deploy@v1
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-east-1
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Environment

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key. | `secrets` | **Yes** |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. | `secrets` | **Yes** |
| `AWS_DEFAULT_REGION` | The region where you created your stack. For example, `us-east-1`. | `env` | **Yes** |
| `GITHUB_TOKEN` | Your GitHub Token. This is contained your workflow. [More info here.](https://help.github.com/en/articles/virtual-environments-for-github-actions#github_token-secret) | `secrets` | **Yes** |

## License

[MIT](../LICENSE)
