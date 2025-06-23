variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

variable "cluster" {
  description = "EKS cluster name"
  type        = string
}

variable "enable" {
  description = "Determine whether to enable or disable Node group"
  type        = bool
  default     = true
}

variable "ami_type" {
  description = "AMI type of the Node group instances"
  type        = string
  default     = null
}

variable "instance_types" {
  description = "Instance types of the Node group instances"
  type        = list(string)
  default     = null
}

variable "capacity_type" {
  description = "Capacity type of the Node group instances"
  type        = string
  default     = null
}

variable "subnets" {
  description = "VPC subnets ID(s) where the Node group will be created"
  type        = list(string)
}

variable "node_role" {
  description = "IAM role name to be used by EC2 nodes"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels for Node group"
  type        = map(string)
  default     = null
}

variable "scaling" {
  description = "Scaling configuration of Node group"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
  nullable = false
}

variable "taints" {
  description = "Taints configuration for Node groups"
  type = map(object({
    value  = optional(string)
    effect = string
  }))
  default = {}
}

variable "update" {
  description = "Update configuration for Node groups"
  type = object({
    max_unavailable            = optional(number, null)
    max_unavailable_percentage = optional(number, null)
  })
  default = {}

  validation {
    condition     = sum([for _, config in var.update : (config != null ? 1 : 0)]) <= 1
    error_message = "Either 'max_unavailable' or 'max_unavailable_percentage' should be set. Both are mutually exclusive"
  }
}

variable "tags" {
  description = "Tags to be assigned to the resources"
  type        = map(string)
  default     = null
}
