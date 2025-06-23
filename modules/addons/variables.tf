variable "cluster" {
  description = "EKS cluster"
  type = object({
    name             = string
    auto_mode        = optional(bool, false)
    node_groups      = optional(bool, false)
    faragte_profiles = optional(bool, false)
  })
}
