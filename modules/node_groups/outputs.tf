output "node_groups_status" {
  description = "Node groups status"
  value       = { for name, config in var.node_groups : name => config.enable }

  depends_on = [aws_eks_node_group.this]
}
