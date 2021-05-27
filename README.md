# Create an ECR repository

![License](https://img.shields.io/github/license/terrablocks/aws-ecr?style=for-the-badge) ![Tests](https://img.shields.io/github/workflow/status/terrablocks/aws-ecr/tests/master?label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/workflow/status/terrablocks/aws-ecr/checkov/master?label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-ecr?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-ecr?style=for-the-badge)

This terraform module will deploy the following services:
- ECR Repository
- ECR Repository Policy
- ECR Repository Lifecycle Policy

# Usage Instructions
## Example
```terraform
module "ecr" {
  source = "github.com/terrablocks/aws-ecr.git"

  name = "backend"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.37.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of ECR repository | `string` | n/a | yes |
| kms_key | ID/Alias/ARN of KMS key to use for SSE encryption. You can skip this to use default AWS managed key | `string` | `"alias/aws/ecr"` | no |
| image_tag_mutability | Whether to allow image overwrite | `string` | `"IMMUTABLE"` | no |
| scan_image_on_push | Enable scanning of container image for vulnerabilities on push | `bool` | `true` | no |
| external_principals | Map of external AWS principals if you want to provide access to other AWS accounts | `map(string)` | `{}` | no |
| delete_after_days | Creates a lifecycle policy to delete container image after X days. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided | `number` | `0` | no |
| delete_after_count | Creates a lifecycle policy to delete container images after a count has reached. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided | `number` | `0` | no |
| tags | Map of key value pair to associate with ECR repo | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of ECR repository |
| id | The registry ID where the repository was created |
| url | URL of the repository |
