# Devops

How to deploy:
- terraform init
- terraform workspace new ${deployment_name}
- terraform apply -var-file="dev.tfvars" or terraform apply -var 'deployment_name=${deployment_name}'
