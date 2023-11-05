data "aws_lb_listener" "listener" {
  load_balancer_arn = var.alb_arn
  port = 80
}

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/apigateway-v2/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues
*/
module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.2.0"
  // Conditions create new environment or not if exist
  create = true
  // If you have domain name -> true
  create_api_domain_name = false

  name          = "${var.name}-gateway-${var.env}"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway with VPC Links"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
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
}