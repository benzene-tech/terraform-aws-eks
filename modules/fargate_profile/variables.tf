variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

variable "cluster" {
  description = "EKS cluster name"
  type        = string
}

variable "pod_execution_role" {
  description = "IAM role name to be used by Fargate profiles"
  type        = string
  default     = null
}

variable "enable" {
  description = "Determine whether to enable or disable Fargate profile"
  type        = bool
  default     = true
}

variable "subnets" {
  description = "VPC subnets ID(s) where the Fargate profiles will be created"
  type        = list(string)
}

variable "selectors" {
  description = "Namespace selectors of Fargate profile"
  type = set(object(
    {
      namespace = string
      labels    = optional(map(string), null)
    }
  ))
  nullable = true
}

variable "tags" {
  description = "Tags to be assigned to the resources"
  type        = map(string)
  default     = null
}
