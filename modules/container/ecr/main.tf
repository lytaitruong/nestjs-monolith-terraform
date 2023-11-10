data "aws_caller_identity" "current" {}

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-ecr/issues
*/
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6"
  // Conditions create new environment or not if exist
  create = var.enable

  repository_name = "${var.name}-${var.env}"

  create_lifecycle_policy = true

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 25 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["any"],
          countType     = "imageCountMoreThan",
          countNumber   = 25
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  repository_force_delete    = true
  repository_encryption_type = "KMS"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}