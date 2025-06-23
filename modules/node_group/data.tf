data "aws_eks_cluster" "this" {
  name = var.cluster
}

data "aws_iam_role" "this" {
  count = var.enable ? 1 : 0

  name = var.node_role

  lifecycle {
    precondition {
      condition     = var.node_role != null
      error_message = "'node_role' is required to create EC2 nodes"
    }
  }
}
