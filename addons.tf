resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name  = aws_eks_cluster.this.id
  addon_name    = replace(each.key, "_", "-")
  addon_version = each.value.version
}
