resource "aws_elasticache_cluster" "redis" {
  count = (var.enable == true && var.enable_cluster == false) ? 1 : 0

  cluster_id = "${var.name}-redis-${var.env}"

  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = "default.redis7"

  node_type       = var.node_type
  num_cache_nodes = var.node_number_cache

  auto_minor_version_upgrade = true

  network_type       = "dual_stack"
  security_group_ids = var.security_group_ids
  subnet_group_name  = var.subnet_group_name

  snapshot_retention_limit = 7
  snapshot_window          = "00:00-03:00"

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  count                = (var.enable == true && var.enable_cluster == true) == true ? 1 : 0
  replication_group_id = "${var.name}-redis-cluster-${var.env}"

  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = "default.redis7.cluster.on"

  node_type               = var.node_type
  num_node_groups         = var.node_number_cache
  replicas_per_node_group = var.replicas_per_node_group

  auto_minor_version_upgrade = true
  automatic_failover_enabled = true

  network_type       = "dual_stack"
  security_group_ids = var.security_group_ids
  subnet_group_name  = var.subnet_group_name

  snapshot_retention_limit = 7
  snapshot_window          = "00:00-03:00"

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}