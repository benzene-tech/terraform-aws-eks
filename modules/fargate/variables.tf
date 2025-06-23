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
  description = "VPC subnets ID(s) where the Fargate profiles will be created"
  type        = list(string)
}

variable "pod_execution_role" {
  description = "IAM role name to be used by Fargate profiles"
  type        = string
  default     = null
}

variable "fargate_profiles" {
  description = "Fargate profiles to be created"
  type = map(object(
    {
      enable  = optional(bool, true)
      subnets = list(string)
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
