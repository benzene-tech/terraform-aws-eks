resource "aws_eks_fargate_profile" "this" {
  for_each = { for name, config in var.fargate_profiles : name => config if config.enable }

  fargate_profile_name   = each.key
  cluster_name           = data.aws_eks_cluster.this.id
  pod_execution_role_arn = one(data.aws_iam_role.this[*].arn)
  subnet_ids             = each.value.subnets

  dynamic "selector" {
    for_each = each.value["selectors"]

    content {
      namespace = selector.value["namespace"]
      labels    = selector.value["labels"]
    }
  }

  tags = var.tags
}
