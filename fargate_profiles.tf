resource "aws_eks_fargate_profile" "this" {
  for_each = { for name, config in var.fargate_profiles : name => config if config.enable }

  fargate_profile_name   = each.key
  cluster_name           = aws_eks_cluster.this.name
  pod_execution_role_arn = one(data.aws_iam_role.fargate_profile[*].arn)
  subnet_ids             = data.aws_subnets.this["private"].ids

  dynamic "selector" {
    for_each = each.value["selectors"]

    content {
      namespace = selector.value["namespace"]
      labels    = selector.value["labels"]
    }
  }

  tags = var.tags
}

resource "aws_eks_fargate_profile" "default" {
  count = anytrue(local.fargate_profile_status) && !try(var.auto_mode.enable, false) && !anytrue(local.node_groups_status) ? 1 : 0

  fargate_profile_name   = "default"
  cluster_name           = aws_eks_cluster.this.name
  pod_execution_role_arn = one(data.aws_iam_role.fargate_profile[*].arn)
  subnet_ids             = data.aws_subnets.this["private"].ids

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }

  tags = var.tags
}
