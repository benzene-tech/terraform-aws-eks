output "fargate_profiles_status" {
  description = "Fargate profiles status"
  value       = var.enable

  depends_on = [aws_eks_fargate_profile.this]
}
