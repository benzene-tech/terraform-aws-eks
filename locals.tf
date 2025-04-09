locals {
  node_groups_status     = [for _, node_group in var.node_groups : node_group.enable]
  fargate_profile_status = [for _, fargate_profile in var.fargate_profiles : fargate_profile.enable]
  required_subnets       = toset(flatten([[var.subnet], [for node_group in var.node_groups : node_group.subnet_type], anytrue(local.fargate_profile_status) ? ["private"] : []]))
  compatible_computes = toset(compact([
    try(var.auto_mode.enable, false) ? "Auto Mode" : null,
    anytrue(local.node_groups_status) ? "EC2" : null,
    anytrue(local.fargate_profile_status) ? "Fargate" : null
  ]))
  addons = {
    kube-proxy = {
      compatible_computes = ["EC2"]
    }
    coredns = {
      compatible_computes = ["EC2", "Fargate"]
    }
    eks-pod-identity-agent = {
      compatible_computes = ["EC2"]
    }
    vpc-cni = {
      compatible_computes = ["EC2"]
      pod_identity_association = {
        role            = "BenzeneCNI"
        service_account = "aws-node"
      }
    }
  }
}
