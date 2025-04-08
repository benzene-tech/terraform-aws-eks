resource "aws_eks_fargate_profile" "this" {
  for_each = var.fargate_profiles

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
  count = length(var.node_groups) == 0 && length(var.node_groups) > 0 ? 1 : 0

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
