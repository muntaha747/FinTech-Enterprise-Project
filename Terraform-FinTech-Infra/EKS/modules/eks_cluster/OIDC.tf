############################ OIDC Provider for IRSA ############################
# IRSA = IAM Roles for Service Accounts.
# It lets a single pod use its own IAM role, instead of every pod sharing the node's role.
#
# How it works, in 3 steps:
#   1. EKS gives every cluster an OIDC "issuer" URL (an identity website for the cluster).
#   2. We read that website's TLS certificate fingerprint so AWS can trust it.
#   3. We register the URL + fingerprint in IAM as an OIDC provider.
# After this, IAM roles can say "trust pods coming from this cluster".

# Step 1 + 2: read the TLS certificate of the cluster's OIDC issuer URL
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks_control_plane.identity[0].oidc[0].issuer
}

# Step 3: register the cluster's OIDC issuer in IAM
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = aws_eks_cluster.eks_control_plane.identity[0].oidc[0].issuer
  client_id_list  = var.oidc_client_id_list
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-OIDC" })
}
