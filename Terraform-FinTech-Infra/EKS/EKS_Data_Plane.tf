########################################### Blue Node group for Core Services###########################################
resource "aws_eks_node_group" "core_data_plane_blue" {
  count           = var.node_color == "blue" || var.node_color == "both" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.data_plane_blue
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = data.terraform_remote_state.networking.outputs.private_subnet_ids["FinTech-App"]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 1
  }
  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

########################################### Green Node group for Core Services############################################
resource "aws_eks_node_group" "core_data_plane_green" {
  count           = var.node_color == "green" || var.node_color == "both" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.data_plane_green
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = data.terraform_remote_state.networking.outputs.private_subnet_ids["FinTech-App"]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 0
    max_size     = 10
    min_size     = 0
  }
  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}


########################################### Blue Node group for ML Services###########################################
resource "aws_eks_node_group" "ml_data_plane_blue" {
  count           = var.node_color == "blue" || var.node_color == "both" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.ml_data_plane_blue
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = data.terraform_remote_state.networking.outputs.private_subnet_ids["FinTech-App"]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 0
    max_size     = 10
    min_size     = 0
  }

  taint {
    key    = "dedicated"
    value  = "ml-inference"
    effect = "NO_SCHEDULE"
  }
  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}


########################################### Green Node group for ML Services###########################################
resource "aws_eks_node_group" "ml_data_plane_green" {
  count           = var.node_color == "green" || var.node_color == "both" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.ml_data_plane_green
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = data.terraform_remote_state.networking.outputs.private_subnet_ids["FinTech-App"]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 0
    max_size     = 10
    min_size     = 0
  }

  taint {
    key    = "dedicated"
    value  = "ml-inference"
    effect = "NO_SCHEDULE"
  }
  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

########################################### Update local kubeconfig after cluster creation ###########################################
# Runs `aws eks update-kubeconfig` on this machine so kubectl works right after `terraform apply`.
# Re-runs automatically if the cluster is recreated (new endpoint).
resource "terraform_data" "update_kubeconfig" {
  triggers_replace = [aws_eks_cluster.eks_control_plane.endpoint]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks_control_plane.name} --region ${var.region}"
  }
  depends_on = [aws_eks_cluster.eks_control_plane]
}
