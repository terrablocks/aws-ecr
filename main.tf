data "aws_kms_key" "repo" {
  key_id = var.kms_key
}

resource "aws_ecr_repository" "repo" {
  # checkov:skip=CKV_AWS_136: SSE is in place using default KMS key
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = var.kms_key == "alias/aws/ecr" ? "AES256" : "KMS"
    kms_key         = var.kms_key == "alias/aws/ecr" ? null : data.aws_kms_key.repo.arn
  }

  image_scanning_configuration {
    scan_on_push = var.scan_image_on_push
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "repo" {
  count      = min(length(var.external_principals), 1)
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow other accounts to pull the image",
      "Effect": "Allow",
      "Principal": ${var.external_principals},
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken"
      ]
    }
  ]
}
EOF
}

locals {
  high_priority = var.delete_after_count > 0 && var.delete_after_days > 0 && var.high_priority != "" ? var.high_priority : (var.delete_after_days > 0 ? "days" : "count")
}

resource "aws_ecr_lifecycle_policy" "days" {
  count      = min(var.delete_after_days, 1)
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": ${local.high_priority == "days" ? 1 : 2},
      "description": "Expire images older than ${var.delete_after_days} days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.delete_after_days}
      },
      "action": {
          "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "count" {
  count      = min(var.delete_after_count, 1)
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": ${local.high_priority == "count" ? 1 : 2},
      "description": "Keep last ${var.delete_after_count} images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": ${var.delete_after_count}
      },
      "action": {
          "type": "expire"
      }
    }
  ]
}
EOF
}
