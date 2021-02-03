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
### Deploy resources
Set profile and region environment variables if applicable.
```shell script
export AWS_PROFILE=my-profile
export AWS_REGION=us-east-1
```
Deploy Terraform resources from the `/terraform` directory.
```shell script
terraform init
terraform apply -var environment=env-name
```
### Teardown resources
Delete all deployed resources.
```shell script
terraform destroy -var environment=env-name
```
