variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

# VPC
variable "subnets" {
  description = "VPC subnets ID(s) where the EKS cluster will be created"
  type        = list(string)
}

# EKS cluster
variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = null
}

variable "enable_public_access_endpoint" {
  description = "Determine whether to enable or disable public access endpoint"
  type        = bool
  default     = true
  nullable    = false
}

variable "public_access_cidrs" {
  description = "List of CIDRs that can access EKS cluster's public endpoint"
  type        = list(string)
  default     = null
}

variable "auto_mode" {
  description = "EKS auto mode configurations"
  type = object({
    enable     = optional(bool, true)
    node_pools = list(string)
  })
  default = null
}

variable "upgrade_policy" {
  description = "Upgrade policy for the EKS cluster"
  type        = string
  default     = "STANDARD"
  nullable    = false
}

variable "bootstrap_cluster_creator" {
  description = "Determine whether to bootstrap the cluster creator with admin permissions in cluster's access config"
  type        = bool
  default     = false
  nullable    = false
}

variable "role" {
  description = "IAM role name for EKS cluster"
  type        = string
}

variable "node_role" {
  description = "IAM role name to be used by EC2 nodes"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be assigned to the resources"
  type        = map(string)
  default     = null
}
