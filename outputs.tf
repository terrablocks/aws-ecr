output "name" {
  value       = aws_ecr_repository.repo.name
  description = "Name of the ECR repository"
}

output "arn" {
  value       = aws_ecr_repository.repo.arn
  description = "ARN of the ECR repository"
}

output "id" {
  value       = aws_ecr_repository.repo.registry_id
  description = "The registry ID where the ECR repository is created"
}

output "url" {
  value       = aws_ecr_repository.repo.repository_url
  description = "URL of the ECR repository"
}
