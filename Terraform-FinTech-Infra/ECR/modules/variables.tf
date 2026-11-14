variable "ecr_repository" {
  type        = set(string)
  description = "List of the repository "
}

variable "image_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "The tag mutability setting for the repository"
}