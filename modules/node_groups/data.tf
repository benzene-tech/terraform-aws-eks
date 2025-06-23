data "aws_eks_cluster" "this" {
  name = var.cluster
}

data "aws_iam_role" "this" {
  count = alltrue([for _, node_groups in var.node_groups : node_groups.enable]) ? 1 : 0

  name = var.node_role

  lifecycle {
    precondition {
      condition     = var.node_role != null
      error_message = "'node_role' is required to create EC2 nodes"
    }
  }
}
