locals {
  bucket_name = "${var.channel_name}-bucket-${var.environment}-${var.region}"
  vpc_name    = var.vpc_name
  instance_type = var.instance_type
  amiid = var.amiid
  channel_name = var.channel_name
  region = var.region
  environment = var.environment
  cidr = var.cidr_block
}