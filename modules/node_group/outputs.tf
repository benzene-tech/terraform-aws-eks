output "node_groups_status" {
  description = "Node groups status"
  value       = var.enable

  depends_on = [aws_eks_node_group.this]
}
