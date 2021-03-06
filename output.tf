output "arn" {
  value = aws_ecr_repository.repo.arn
}

output "id" {
  value = aws_ecr_repository.repo.registry_id
}

output "url" {
  value = aws_ecr_repository.repo.repository_url
}
