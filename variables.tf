variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

# VPC
variable "vpc_id" {
  description = "VPC ID. If VPC ID is not provided default VPC will be used"
  type        = string
  default     = null
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

variable "subnet" {
  description = "Subnet type where the EKS cluster will be created"
  type        = string
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["public", "private"], var.subnet)
    error_message = "Subnet type should be either 'public' or 'private'"
  }
}

variable "auto_mode" {
  description = "Determine whether to enable or disable EKS auto mode"
  type = object({
    enable     = optional(bool, true)
    node_pools = optional(list(string), null)
  })
  default  = {}
  nullable = false
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
  default     = null
}

variable "node_role" {
  description = "IAM role name to be used by EC2 nodes"
  type        = string
  default     = null
}

variable "fargate_profile_pod_execution_role" {
  description = "IAM role name to be used by Fargate profiles"
  type        = string
  default     = null
}

variable "node_groups" {
  description = "Node groups to be created"
  type = map(object(
    {
      enable         = optional(bool, true)
      ami_type       = optional(string, null)
      instance_types = optional(list(string), null)
      capacity_type  = optional(string, "ON_DEMAND")
      labels         = optional(map(string), null)
      subnet_type    = optional(string, "private")
      taints = optional(map(object({
        value  = optional(string)
        effect = string
      })), {})
      scaling = object({
        desired_size = number
        min_size     = number
        max_size     = number
      })
      update = optional(object({
        max_unavailable            = optional(number, null)
        max_unavailable_percentage = optional(number, null)
      }), {})
    }
  ))
  default  = {}
  nullable = false

  validation {
    condition     = alltrue([for node_group in var.node_groups : contains(["public", "private"], node_group.subnet_type)])
    error_message = "Subnet type should be either 'public' or 'private'"
  }

  validation {
    condition     = alltrue([for node_group in var.node_groups : contains(["ON_DEMAND", "SPOT"], node_group.capacity_type)])
    error_message = "Capacity type should be either 'ON_DEMAND' or 'SPOT'"
  }

  validation {
    condition     = alltrue([for node_group in var.node_groups : (sum([for config in node_group.update : (config != null ? 1 : 0)]) <= 1)])
    error_message = "Either 'max_unavailable' or 'max_unavailable_percentage' should be set. Both are mutually exclusive"
  }
}

variable "fargate_profiles" {
  description = "Fargate profiles to be created"
  type = map(object(
    {
      enable = optional(bool, true)
      selectors = set(object(
        {
          namespace = string
          labels    = optional(map(string))
        }
      ))
    }
  ))
  default  = {}
  nullable = false
}

variable "tags" {
  description = "Tags to be assigned to the resources"
  type        = map(string)
  default     = null
}
