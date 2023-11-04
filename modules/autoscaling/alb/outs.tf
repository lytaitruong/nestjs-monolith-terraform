output "id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.id
}

output "arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.arn
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.dns_name
}

output "alb_target_group_names_arns" {
  description = "List target group name and arns"
  value       = module.alb.target_groups
}
