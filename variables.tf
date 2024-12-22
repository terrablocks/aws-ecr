variable "name" {
  type        = string
  description = "Name of ECR repository"
}

variable "kms_key" {
  type        = string
  default     = "alias/aws/ecr"
  description = "ID/Alias/ARN of KMS key to use for SSE encryption. You can skip this to use default AWS managed key"
}

variable "force_delete" {
  type        = bool
  default     = true
  description = "Delete the ECR repository even if it contains images"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "Whether to allow image overwrite"
}

variable "scan_image_on_push" {
  type        = bool
  default     = true
  description = "Enable scanning of container image for vulnerabilities on push"
}

variable "ecr_resource_policy" {
  type        = string
  default     = ""
  description = "To attach a resource policy to ECR repository provide a JSON formatted policy document. Refer to [AWS doc](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html) for creating the policy document"
}

variable "apply_default_lifecycle_policy" {
  type        = bool
  default     = true
  description = "Whether to create a lifecycle policy to delete container image after 30 days. Set this to false if you are passing custom policy"
}

variable "custom_lifecycle_policy" {
  type        = string
  default     = ""
  description = "Pass a custom JSON formatted string policy document. Refer to [AWS doc](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) for creating the policy document"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with ECR repo"
}
