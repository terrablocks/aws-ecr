data "aws_kms_key" "repo" {
  key_id = var.kms_key
}

resource "aws_ecr_repository" "repo" {
  # checkov:skip=CKV_AWS_136: SSE is in place using default KMS key
  name                 = var.name
  force_delete         = var.force_delete
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

resource "aws_ecr_repository_policy" "this" {
  count      = var.ecr_resource_policy != "" ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy     = var.ecr_resource_policy
}

locals {
  default_lifecycle_rule = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.apply_default_lifecycle_policy || var.custom_lifecycle_policy != "" ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy     = var.apply_default_lifecycle_policy ? local.default_lifecycle_rule : var.custom_lifecycle_policy
}
