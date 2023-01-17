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
  days_rule = {
    rulePriority = local.high_priority == "days" ? 1 : 2,
    description  = "Expire images older than ${var.delete_after_days} day(s)",
    selection = {
      tagStatus   = "any",
      countType   = "sinceImagePushed",
      countUnit   = "days",
      countNumber = var.delete_after_days
    },
    action = {
      type = "expire"
    }
  }
  count_rule = {
    rulePriority = local.high_priority == "count" ? 1 : 2,
    description  = "Keep last ${var.delete_after_count} image(s)",
    selection = {
      tagStatus   = "any",
      countType   = "imageCountMoreThan",
      countNumber = var.delete_after_count
    },
    action = {
      type = "expire"
    }
  }
  lifecycle_policy_rules = var.delete_after_count > 0 && var.delete_after_days > 0 ? [local.days_rule, local.count_rule] : (var.delete_after_days > 0 ? [local.days_rule] : [local.count_rule])
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.delete_after_days > 0 || var.delete_after_count > 0 ? 1 : 0
  repository = aws_ecr_repository.repo.name

  policy = jsonencode(
    {
      rules = local.lifecycle_policy_rules
    }
  )
}
