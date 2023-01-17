# Usage

## Initialize Project's Backend

create `backend.conf` with this configuration

```conf
bucket     = "${S3_BUCKET}"
encrypt    = "${S3_BUCKET_ENCRYPTION_FOR_OBJECT}"
region     = "${S3_REGION}"
key        = "${TERRAFORN_STATE_KEY}"
access_key = "${AWS_ACCESS_KEY}"
secret_key = "${AWS_SECRET_KEY}"
```

execute this command
```
terraform init -backend-config backend.conf
```

## Deploy the project

create enviromental configuration for deployment, example `test.tfvars`

```tfvars
aws_access_id       = "${AWS_ACCESS_KEY}"
aws_secret_key_id   = "${AWS_SECRET_KEY}"
app_name            = "${APP_NAME}"
vpc_id              = "${AWS_VPC_ID}"
environment         = "${SERVER_ENVIRONMENT}"
subnet_id           = "${AWS_SUBNET_ID}"
key_name            = "${EC2_KEY_PAIR_NAME}"

```

execute this command

```
terraform apply -var-file {enviromental_configuration}.tfvars 
```


## Destroy this project
```
terraform destroy -var-file {enviromental_configuration}.tfvars 
```