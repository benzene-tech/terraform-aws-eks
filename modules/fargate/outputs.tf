output "fargate_profiles_status" {
  description = "Fargate profiles status"
  value       = { for name, config in var.fargate_profiles : name => config.enable }

  depends_on = [aws_eks_fargate_profile.this]
}
