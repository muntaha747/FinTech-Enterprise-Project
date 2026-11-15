# main.tf: WHAT to build. Every value comes from locals.tf.
module "infrastructure_compliance_storage" {
  source       = "./modules/"
  environment  = local.environment
  bucket_names = local.bucket_names
  tags         = local.common_tags
}