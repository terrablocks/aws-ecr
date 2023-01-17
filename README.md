# Create an ECR repository

![License](https://img.shields.io/github/license/terrablocks/aws-ecr?style=for-the-badge) ![Tests](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-ecr/tests.yml?branch=master&label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-ecr/checkov.yml?branch=master&label=Test&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-ecr?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-ecr?style=for-the-badge)

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
| terraform | >= 1.0 |
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of ECR repository | `string` | n/a | yes |
| kms_key | ID/Alias/ARN of KMS key to use for SSE encryption. You can skip this to use default AWS managed key | `string` | `"alias/aws/ecr"` | no |
| image_tag_mutability | Whether to allow image overwrite | `string` | `"IMMUTABLE"` | no |
| scan_image_on_push | Enable scanning of container image for vulnerabilities on push | `bool` | `true` | no |
| ecr_resource_policy | To attach a resource policy to ECR repository provide a JSON formatted policy document. Refer to [AWS doc](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html) for creating the policy document | `string` | `""` | no |
| apply_default_lifecycle_policy | Whether to create a lifecycle policy to delete container image after 30 days. Set this to false if you are passing custom policy | `bool` | `true` | no |
| custom_lifecycle_policy | Pass a custom JSON formatted string policy document. Refer to [AWS doc](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) for creating the policy document | `string` | `""` | no |
| tags | Map of key value pair to associate with ECR repo | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of ECR repository |
| id | The registry ID where the repository was created |
| url | URL of the repository |
