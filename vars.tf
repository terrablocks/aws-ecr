variable "name" {
  type        = string
  description = "Name of ECR repository"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "ID/Alias/ARN of KMS key to use for SSE encryption. You can skip this to use default AWS managed key"
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

variable "external_principals" {
  type        = map(string)
  default     = {}
  description = "Map of external AWS principals if you want to provide access to other AWS accounts"
}

variable "delete_after_days" {
  type        = number
  default     = 0
  description = "Creates a lifecycle policy to delete container image after X days. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided"
}

variable "delete_after_count" {
  type        = number
  default     = 0
  description = "Creates a lifecycle policy to delete container images after a count has reached. **Note:** Either `delete_after_days` or `delete_after_count` has to be provided"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with ECR repo"
}
