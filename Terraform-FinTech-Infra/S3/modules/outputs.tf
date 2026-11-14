# outputs.tf: values this module hands back to the root.

# List of all bucket ARNs, e.g. ["arn:aws:s3:::fintech-applog", ...]
output "bucket_arns" {
  description = "ARNs of all buckets created by this module"
  value       = values(aws_s3_bucket.compliance_bucket)[*].arn
}
