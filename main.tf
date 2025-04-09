resource "aws_eks_cluster" "this" {
  name                          = var.name
  role_arn                      = data.aws_iam_role.cluster.arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = false

  vpc_config {
    subnet_ids              = data.aws_subnets.this[var.subnet].ids
    public_access_cidrs     = var.enable_public_access_endpoint ? var.public_access_cidrs : null
    endpoint_public_access  = var.enable_public_access_endpoint
    endpoint_private_access = true
  }

  compute_config {
    enabled       = var.auto_mode.enable
    node_pools    = var.auto_mode.node_pools
    node_role_arn = one(data.aws_iam_role.node_group[*].arn)
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

  lifecycle {
    precondition {
      condition     = length(data.aws_subnets.this[var.subnet].ids) > 1
      error_message = "Required at least two subnets of same type to create EKS cluster"
    }
  }
}

check "cluster_subnet" {
  assert {
    condition     = var.subnet == "private"
    error_message = "AWS recommends to create EKS clusters in private subnets, if possible"
  }
}
