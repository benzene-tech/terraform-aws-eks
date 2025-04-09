data "aws_vpc" "this" {
  id      = var.vpc_id
  default = var.vpc_id == null ? true : null
}

data "aws_subnets" "this" {
  for_each = local.required_subnets

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = [each.value == "public" ? "true" : "false"]
  }
}

data "aws_iam_role" "cluster" {
  name = var.role
}

data "aws_iam_role" "node_group" {
  count = try(var.auto_mode.enable, false) || anytrue(local.node_groups_status) ? 1 : 0

  name = var.node_role

  lifecycle {
    precondition {
      condition     = var.node_role != null
      error_message = "'node_role' is required to create EC2 nodes"
    }
  }
}

data "aws_iam_role" "fargate_profile" {
  count = anytrue(local.fargate_profile_status) ? 1 : 0

  name = var.fargate_profile_pod_execution_role

  lifecycle {
    precondition {
      condition     = var.fargate_profile_pod_execution_role != null
      error_message = "'fargate_profile_pod_execution_role' is required to create Fargate profiles"
    }
  }
}

data "aws_iam_role" "addon" {
  for_each = { for name, config in local.addons : name => config.pod_identity_association.role if can(config.pod_identity_association) && length(setintersection(local.compatible_computes, toset(config.compatible_computes))) > 0 }

  name = each.value
}
