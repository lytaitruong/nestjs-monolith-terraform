// https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
// Only use if you have buy domain name in Route53 or Cloudfare
# data "aws_acm_certificate" "acm_certificate_issued" {
#   domain   = var.app_domain_cert
#   statuses = ["ISSUED"]
# }

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-alb/issues
*/
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.1.0"
  // Conditions create new environment or not if exist
  create = true

  name               = var.name
  load_balancer_type = "application"

  internal        = true
  ip_address_type = "dualstack"

  vpc_id          = var.vpc_id
  subnets         = var.vpc_subnets
  security_groups = var.security_groups

  idle_timeout                                = 300
  enable_http2                                = true
  preserve_host_header                        = true
  enable_xff_client_port                      = true
  enable_cross_zone_load_balancing            = true
  enable_tls_version_and_cipher_suite_headers = true
  enable_waf_fail_open                        = false
  enable_deletion_protection                  = false

  target_groups = {
    "${var.name}-tgg-${var.env}" = {
      name                              = "${var.name}-tgg-${var.env}"
      target_type                       = var.app_type
      backend_port                      = var.app_port
      ip_address_type                   = "ipv6"
      backend_protocol                  = "HTTP"
      protocol_version                  = var.app_enable_tls ? "HTTP2" : "HTTP1"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true
      health_check = {
        path                = var.app_path
        port                = "traffic-port"
        enabled             = true
        interval            = 30
        protocol            = "HTTP"
        timeout             = 10
        healthy_threshold   = 5
        unhealthy_threshold = 5
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "${var.name}-tgg-${var.env}"
        Environment            = "true"
      }
      stickiness = {
        type            = "lb_cookie"
        enabled         = true
        cookie_duration = 3600
      }
      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }
  /**
    ** When you don't have domain name
  */
  listeners = {
    http-tcp = {
      port        = 80
      protocol    = "HTTP"
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Nothing to see here... Move along!"
        status_code  = "404"
      }
      rules = {
        main-request = {
          priority = 1
          actions = [
            {
              type             = "forward"
              target_group_key = "${var.name}-tgg-${var.env}"
              stickiness = {
                enabled  = true
                duration = 600
              }
            }
          ]
          conditions = [{
            path_pattern = {
              values = [var.app_path]
            }
          }]
          tags = { Name = "main-request" }
        }
      }
    }
  }
  /**
    ** When you have domain name
  */
  # listeners = {
  #   http-redirect-https = {
  #     port     = 80
  #     protocol = "HTTP"
  #     redirect = {
  #       port        = "443"
  #       protocol    = "HTTPS"
  #       status_code = "HTTP_301"
  #     }
  #   }
  #   https-tls = {
  #     port            = 443
  #     protocol        = "HTTPS"
  #     ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  #     certificate_arn = data.aws_acm_certificate.acm_certificate_issued
  #     action_type     = "fixed-response"
  #     fixed_response = {
  #       content_type = "text/plain"
  #       message_body = "Nothing to see here... Move along!"
  #       status_code  = "404"
  #     }
  #     rules = {
  #       main-request = {
  #         priority = 1
  #         actions = [
  #           {
  #             type             = "forward"
  #             target_group_key = "${var.name}-tgg-${var.env}"
  #             stickiness = {
  #               enabled  = true
  #               duration = 600
  #             }
  #           }
  #         ]
  #         conditions = [{
  #           path_pattern = {
  #             values = [var.app_path]
  #           }
  #         }]
  #         tags = { Name = "main-request" }
  #       }
  #     }
  #   }
  # }

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

