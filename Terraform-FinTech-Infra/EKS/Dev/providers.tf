# providers.tf: which cloud to talk to, and how to reach the cluster

provider "aws" {
  region = var.region
}

# Helm provider: lets Terraform install Helm charts into the EKS cluster.
# It connects to the cluster's API using the cluster's endpoint and certificate,
# and gets a short-lived login token from the AWS CLI (same way kubectl does).
provider "helm" {
  kubernetes = {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name, "--region", var.region]
    }
  }
}
