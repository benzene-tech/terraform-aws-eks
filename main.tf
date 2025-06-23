resource "aws_eks_cluster" "this" {
  name                          = var.name
  role_arn                      = data.aws_iam_role.cluster.arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = false

  vpc_config {
    subnet_ids              = var.subnets
    public_access_cidrs     = var.enable_public_access_endpoint ? var.public_access_cidrs : null
    endpoint_public_access  = var.enable_public_access_endpoint
    endpoint_private_access = true
  }

  compute_config {
    enabled       = try(var.auto_mode.enable, false)
    node_pools    = try(var.auto_mode.node_pools, null)
    node_role_arn = one(data.aws_iam_role.node[*].arn)
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = try(var.auto_mode.enable, false)
    }
  }

  storage_config {
    block_storage {
      enabled = try(var.auto_mode.enable, false)
    }
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator
  }

  upgrade_policy {
    support_type = var.upgrade_policy
  }

  tags = var.tags
}
