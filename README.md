# Create a ECR repository

This terraform module will create the following:
- ECR Repository
- ECR Repository Policy
- ECR Repository Lifecycle Policy

## Licence:
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

MIT Licence. See [Licence](LICENCE) for full details.

# Usage Instructions:
## Example:
```terraform
module "ecr" {
  source = "github.com/terrablocks/aws-ecr.git"

  name = "backend"
}
```

## Variables
| Parameter             | Type    | Description          | Default       | Required |
|-----------------------|---------|----------------------|---------------|----------|
| name                | string  | Name if ECR repo                                                      |              | Y        |
| kms_key         | string  | ID/Alias/ARN of KMS key to use for SSE encryption. You can skip this to use default AWS managed key        |              | N        |
| image_tag_mutability            | string    | Whether to allow image overwrite                                 | IMMUTABLE             | N        |
| scan_image_on_push            | boolean    | Scan container image for vulnerabilities on push                                            | true      | N        |
| external_principals            | map    | Map of external AWS principals if you want to provide access to other AWS accounts                       |              | N        |
| delete_after_days            | number    | Creates a lifecycle policy to delete container image after X days. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided                      | 0             | N        |
| delete_after_count            | number    | Creates a lifecycle policy to delete container images after a count has reached. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided                     | 0             | N        |
| tags            | map    | Map of key value pair to associate with ECR repo                      |              | N        |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| arn           | string | ARN of ECR repository            |
| id           | string | The registry ID where the repository was created            |
| url           | string | URL of the repository            |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)
