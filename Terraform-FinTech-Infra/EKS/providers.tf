provider "aws" {
  region = var.region
}

# Helm provider: lets Terraform install Helm charts into the EKS cluster.
# It connects to the cluster's API using the cluster's endpoint and certificate,
# and gets a short-lived login token from the AWS CLI (same way kubectl does).
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks_control_plane.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_control_plane.certificate_authority[0].data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_control_plane.name, "--region", var.region]
    }
  }
}
