resource "aws_eks_fargate_profile" "this" {
  fargate_profile_name   = var.name
  cluster_name           = data.aws_eks_cluster.this.id
  pod_execution_role_arn = one(data.aws_iam_role.this[*].arn)
  subnet_ids             = var.subnets

  dynamic "selector" {
    for_each = var.selectors

    content {
      namespace = selector.value["namespace"]
      labels    = selector.value["labels"]
    }
  }

  tags = var.tags
}
