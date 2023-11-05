// Only use if you have buy domain name in Route53 or Cloudfare
data "aws_lb_listener" "listener" {
  load_balancer_arn = var.alb_arn
  port = var.acm_cert_domain != null ? 443 : 80
}

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/apigateway-v2/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues
*/
module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.2.0"
  // Conditions create new environment or not if exist
  create = var.enable_api_gateway
  // If you have domain name -> true
  create_api_domain_name = false

  name          = "${var.name}-gateway-${var.env}"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway with VPC Links"

  cors_configuration = {
    max_age = 86400
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
    allow_credentials = true
    expose_headers = ["content-disposition"]
  }

  default_route_settings = {
    detailed_metrics_enabled = false
    throttling_burst_limit = 5000
    throttling_rate_limit = 10000
  }

  integrations = {
    "ANY /{proxy+}" = {
      vpc_link           = "${var.name}-vpc-links-${var.env}"
      connection_type    = "VPC_LINK"
      integration_uri    = data.aws_lb_listener.listener.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
      timeout_milliseconds = 15000
    }
  }

  vpc_links = {
    "${var.name}-vpc-links-${var.env}" = {
      name               = "${var.name}-vpc-links-${var.env}"
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  tags = {
    Terraform = "true"
    Environment = var.env
  }
}