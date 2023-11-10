data "aws_kms_alias" "kms_s3" {
  name = "alias/aws/s3"
}
/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/issues
*/
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1"
  // Conditions create new environment or not if exist
  create_bucket = var.enable
  # Allow deletion of non-empty bucket
  force_destroy = true

  bucket = "${var.name}-${var.env}"
  acl    = var.type

  object_ownership         = "BucketOwnerEnforced"
  object_lock_enabled      = false
  control_object_ownership = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
        kms_master_key_id = data.aws_kms_alias.kms_s3.arn
      }
      bucket_key_enabled = true
    }
  }
  versioning = {
    enabled    = var.enabled_version
    mfa_delete = false
  }
  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}