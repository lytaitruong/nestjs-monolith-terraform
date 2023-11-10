/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/cloudfront/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues
*/

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.2.1"
  // Conditions create new environment or not if exist
  create_distribution = var.enable

  enabled         = true
  is_ipv6_enabled = true

  http_version        = "http2and3"
  price_class         = var.price_class
  retain_on_delete    = false
  wait_for_deployment = false

  create_monitoring_subscription = false
  create_origin_access_identity  = false

  create_origin_access_control = true
  origin_access_control = {
    "${var.s3_bucket_id}" = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    "${var.s3_bucket_id}" = {
      domain_name           = var.s3_regional_domain_name
      origin_access_control = "${var.s3_bucket_id}"
      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
      origin_shield = var.enable_shield ? {
        enabled              = var.enable_shield
        origin_shield_region = var.region
      } : {}
    }
  }
  default_cache_behavior = {
    path_pattern           = "*"
    compress               = true
    query_string           = true
    use_forwarded_values   = false
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.s3_bucket_id}"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
    # restrict viewer access
    trusted_key_groups = var.trusted_key_groups
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/errors/404.html"
    }, {
    error_code         = 403
    response_code      = 403
    response_page_path = "/errors/403.html"
  }]

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  depends_on = [module.cloudfront]
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.s3_bucket_id
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${var.s3_bucket_arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "${module.cloudfront.cloudfront_distribution_arn}"
          }
        }
      }
    ]
  })
}
