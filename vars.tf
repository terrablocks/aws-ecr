variable "name" {}

variable "kms_key" {
  default = null
}

variable "image_tag_mutability" {
  default = "IMMUTABLE"
}

variable "scan_image_on_push" {
  default = true
}

variable "external_principals" {
  type    = map(any)
  default = {}
}

variable "delete_after_days" {
  default = 0
}

variable "delete_after_count" {
  default = 0
}

variable "tags" {
  type = map(any)
}
