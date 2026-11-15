# variables.tf: every value main.tf uses.

variable "repository_names" {
  description = "Names of the ECR repositories to create"
  type        = list(string)
}

variable "image_mutability" {
  description = "Tag mutability: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "encryption_type" {
  description = "Image encryption: KMS (AWS KMS key) or AES256 (basic S3-managed key)"
  type        = string
  default     = "KMS"
}

variable "scan_on_push" {
  description = "Scan images for vulnerabilities when they are pushed"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags added to every repository"
  type        = map(string)
  default     = {}
}
