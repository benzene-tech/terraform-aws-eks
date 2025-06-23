locals {
  compatible_computes = toset(compact([
    var.cluster.auto_mode ? "Auto Mode" : null,
    var.cluster.node_groups ? "EC2" : null,
    var.cluster.faragte_profiles ? "Fargate" : null
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
