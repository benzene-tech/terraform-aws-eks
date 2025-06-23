data "aws_eks_cluster" "this" {
  name = var.cluster
}

data "aws_iam_role" "this" {
  count = alltrue([for _, fargate_profile in var.fargate_profiles : fargate_profile.enable]) ? 1 : 0

  name = var.pod_execution_role

  lifecycle {
    precondition {
      condition     = var.pod_execution_role != null
      error_message = "'pod_execution_role' is required to create Fargate profiles"
    }
  }
}
