output "arn" {
  value       = aws_ecr_repository.repo.arn
  description = "ARN of ECR repository"
}

output "id" {
  value       = aws_ecr_repository.repo.registry_id
  description = "The registry ID where the repository was created"
}

output "url" {
  value       = aws_ecr_repository.repo.repository_url
  description = "URL of the repository"
}
