# Terraform - Azuzre Registered App

## pre-requisites

```console
sudo snap install terraform-cli
## snap version of azure cli does not appear to work well with the above terraform install
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

1. A broeser should open and ask you to log into your Azure Subscription.
1. Provide your credentials and if succesful it will tell you the cli has been logged in.
1. When asked to select your subscription and tenant choose the correct value.

## Setup

```console
terraform init
terraform plan --auto-approve
terraform apply --auto-approve
```

## Tear Down

```console
terraform destroy --auto-approve
```
