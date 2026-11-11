# variables.tf: every value main.tf uses. Defaults are the standard settings;
# the root module only passes a value when it wants something different.

########## Buckets ##########
variable "bucket_names" {
  description = "Names of the S3 buckets to create (must be globally unique)"
  type        = list(string)
}

variable "environment" {
  description = "Environment tag value, e.g. production"
  type        = string
  default     = "production"
}

########## Tags ##########
variable "managed_by" {
  description = "Value of the ManagedBy tag"
  type        = string
  default     = "Terraform-Platform-Engine"
}

variable "tags" {
  description = "Extra tags added to every bucket"
  type        = map(string)
  default     = {}
}

########## Versioning ##########
variable "versioning_status" {
  description = "Bucket versioning: Enabled or Suspended"
  type        = string
  default     = "Enabled"
}

########## Lifecycle rule ##########
variable "lifecycle_rule_id" {
  description = "Name of the lifecycle rule"
  type        = string
  default     = "platform-compliance-lifecycle-policy"
}

variable "lifecycle_rule_status" {
  description = "Lifecycle rule on or off: Enabled or Disabled"
  type        = string
  default     = "Enabled"
}

variable "infrequent_access_days" {
  description = "Days before objects move to the infrequent access tier"
  type        = number
  default     = 30
}

variable "infrequent_access_storage_class" {
  description = "Storage class for the infrequent access tier"
  type        = string
  default     = "STANDARD_IA"
}

variable "archive_days" {
  description = "Days before objects move to the archive tier"
  type        = number
  default     = 180
}

variable "archive_storage_class" {
  description = "Storage class for the archive tier"
  type        = string
  default     = "GLACIER"
}

variable "expiration_days" {
  description = "Days before objects are deleted"
  type        = number
  default     = 730
}

variable "noncurrent_archive_days" {
  description = "Days before OLD versions move to the archive tier"
  type        = number
  default     = 90
}

variable "noncurrent_expiration_days" {
  description = "Days before OLD versions are deleted"
  type        = number
  default     = 180
}
