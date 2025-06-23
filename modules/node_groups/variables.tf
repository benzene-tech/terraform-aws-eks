variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

variable "cluster" {
  description = "EKS cluster name"
  type        = string
}

variable "subnets" {
  description = "VPC subnets ID(s) where the Node groups will be created"
  type        = list(string)
}

variable "node_role" {
  description = "IAM role name to be used by EC2 nodes"
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
      subnets        = list(string)
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

variable "tags" {
  description = "Tags to be assigned to the resources"
  type        = map(string)
  default     = null
}
