## Magnetathon 10 Project

This project makes it easy to host a secure static website on AWS with Terraform. The scripts in `devops/terraform` are configured to upload all files in the `ui/magnetathon/out` folder to an S3 bucket. They are then served through a CloudFront distribution. You can set up separate deployments that use different subdomains, e.g. `dev.magnetathon-mm.click` or `test.magnetathon-mm.click`

### Technologies

- [AWS Services](https://aws.amazon.com/)
  - S3, Route53, ACM, CloudFront
- [Next.js](https://nextjs.org/)
- [Terraform](https://www.terraform.io/)

## Getting Started

### Prerequisites

- AWS Account with administrator-level access. [Sign up for AWS here](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html).
- AWS CLI (v2 is recommended) must be installed and configured. [Install here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
- Terraform. [Install here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- You must have a domain configured to use Route 53. If you register a domain with Route 53, AWS will automatically make Route 53 DNS service for the domain. [Learn more here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/MigratingDNS.html).

### Set-up UI

1. Change directories
   ```sh
   cd ui/magnetathon/
   ```
2. Install NPM packages
   ```sh
   npm install
   ```
3. Generate static site files. This will generate the folder `ui/magnetathon/out`.
   ```sh
   npm run build
   ```

### Deployment

1. Change directories
   ```sh
   cd devops/terraform/
   ```
2. Initialize terraform
   ```sh
   terraform init
   ```
3. Create the appropriate terraform workspace. Insert the name of your depoyment here.
   ```sh
   terraform workspace new ${deployment_name}
   ```
   or, if the workspace already exists
   ```sh
   terraform workspace select ${deployment_name}
   ```
4. Create your resources
   ```sh
   terraform apply -var "deployment_name=${deployment_name}"
   ```
   or, if you've created a *tfvars file for your configuration
   ```sh
   terraform apply -var-file="tfvars/${file_name}.tfvars"
   ```

### Clean-up

To remove the resources you have created, simply run:
```sh
terraform destroy -var "deployment_name=${deployment_name}"
```
or 
```sh
terraform destroy -var-file="tfvars/${file_name}.tfvars"
```
depending on what `apply` command you ran earlier.