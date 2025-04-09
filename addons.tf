resource "aws_eks_addon" "this" {
  for_each = { for name, config in local.addons : name => config if length(setintersection(local.compatible_computes, toset(config.compatible_computes))) > 0 }

  cluster_name  = aws_eks_cluster.this.id
  addon_name    = each.key
  addon_version = lookup(each.value, "version", null)

  dynamic "pod_identity_association" {
    for_each = flatten([lookup(each.value, "pod_identity_association", [])])

    content {
      role_arn        = data.aws_iam_role.addon[each.key]
      service_account = pod_identity_association.value.service_account
    }
  }

  depends_on = [aws_eks_node_group.this, aws_eks_fargate_profile.default, aws_eks_fargate_profile.this]
}
