output "name" {
  description = "Cluster name"
  value       = aws_eks_cluster.this.id
}

output "version" {
  description = "Cluster version"
  value       = aws_eks_cluster.this.version
}

output "auto_mode" {
  description = "Determine whether EKS auto mode is enabled or not"
  value       = try(var.auto_mode.enable, false)
}
