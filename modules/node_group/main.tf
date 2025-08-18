resource "aws_eks_node_group" "this" {
  node_group_name = var.name
  cluster_name    = data.aws_eks_cluster.this.id
  version         = data.aws_eks_cluster.this.version
  ami_type        = var.ami_type
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type
  labels          = var.labels
  subnet_ids      = var.subnets
  node_role_arn   = one(data.aws_iam_role.this[*].arn)

  dynamic "taint" {
    for_each = var.taints

    content {
      key    = taint.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  scaling_config {
    desired_size = var.scaling.desired_size
    max_size     = var.scaling.max_size
    min_size     = var.scaling.min_size
  }

  update_config {
    max_unavailable            = var.update.max_unavailable_percentage == null ? coalesce(var.update.max_unavailable, 1) : null
    max_unavailable_percentage = var.update.max_unavailable_percentage
  }

  tags = var.tags
}
