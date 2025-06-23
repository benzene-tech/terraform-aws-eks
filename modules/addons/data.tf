data "aws_eks_cluster" "this" {
  name = var.cluster.name
}

data "aws_iam_role" "addon" {
  for_each = { for name, config in local.addons : name => config.pod_identity_association.role if can(config.pod_identity_association) && length(setintersection(local.compatible_computes, toset(config.compatible_computes))) > 0 }

  name = each.value
}
