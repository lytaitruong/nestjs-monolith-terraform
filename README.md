<p align="center">
  <a href="https://aws.amazon.com/" alt="AWS" target="_blank">
    <img src="https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white" />
  </a>
  <a href="https://www.terraform.io/" alt="Terraform" target="_blank">
    <img src="https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" />
  </a>
  <a href="https://www.ansible.com/" alt="Ansible" target="_blank">
    <img src="https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white" />
  </a>
</p>

# Terraform

- This is a [AWS](https://aws.amazon.com) by using Terraform for [NestJS monolith](https://github.com/lytaitruong/nestjs-monolith-boilerplate)

# Guide how to use

- Configuration AWS Account
  - Run `EXPORT AWS_ACCESS_KEY={your access key}`
  - Run `EXPORT AWS_SECRET_ACCESS_KEY={your secret key}`
  - Run `EXPORT AWS_REGION={your region}`
- State Management
  - S3
    - Go to [AWS S3 Console](https://s3.console.aws.amazon.com/s3/home)
    - Create bucket name `${nestjs-monolith-terraform}`
- Choose environment
  - Moving inside folder 'envs' and choose environment you want to run
  - Overview the `vars.tf` file and make sure everything is match with your AWS account & region
  - Run `terraform init` to initial workspace
  - Run `terraform plan` to check resources on your AWS region and review all resources will be create & update
  - Run `terraform apply` to apply the configuration
- Delete all
  - Run `terraform destroy` to destroy all removed all AWS configuration

## Features

- Security
  - [ ] Setup IAM
  - [ ] Setup SCM
- Network
  - [x] Setup VPC
  - [ ] Setup Security Group
- Storage
  - [ ] Setup S3
  - [ ] Setup Cloudfront
- Database
  - [ ] RDS PostgreSQL
  - [ ] RDS RedisCache
- AutoScaling
  - [ ] Setup API Gateway
  - [ ] Setup ALB
  - [ ] Setup TargetGroup
- Container
  - [ ] Setup ECR
  - [ ] Setup ECS
- Monitoring
  - [ ] Setup Cloudwatch

## Reference

[Learning](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
