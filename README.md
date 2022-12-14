# aws-serverless-infrastructure

## Typescript Functions
### Setup
Install yarn.
```shell script
npm install -g yarn
# or
brew install yarn
```

Install node dependencies in the `node-functions/notes` directory.
```shell script
yarn install
```

## Terraform
The `terraform` directory serves as the optional entry point when we want a remote backend,
e.g. for environment deployments. The `terraform/resources` directory has all the resources
and can be used for local and test environment deployments.
### Deploy resources locally
Set profile and region environment variables if applicable.
```shell script
export AWS_PROFILE=my-profile
export AWS_REGION=us-east-1
```
Deploy Terraform resources from the `/terraform/resources` directory.
```shell script
terraform init
terraform apply -var environment=env-name
```
### Teardown resources
Delete all deployed resources.
```shell script
terraform destroy -var environment=env-name
```

## Links
- Sonar: https://sonarcloud.io/dashboard?id=notes-lambda-functions