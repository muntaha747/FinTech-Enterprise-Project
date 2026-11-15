# EKS_Data_Plane.tf: the worker nodes. Four managed node groups:
#   core blue / core green  -> normal application pods
#   ml blue   / ml green    -> ML inference pods only (tainted)
#
# var.node_color decides which colour exists: "blue", "green" or "both".
#   count = 1 -> the node group is created, count = 0 -> it is not.
# Upgrade without downtime: blue -> both -> green.

locals {
  create_blue  = var.node_color == "blue" || var.node_color == "both"
  create_green = var.node_color == "green" || var.node_color == "both"
}

############################ Core services: BLUE node group ############################
resource "aws_eks_node_group" "core_data_plane_blue" {
  count           = local.create_blue ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.data_plane_blue
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.core_blue_node_count # starting size only; the Cluster Autoscaler changes it later
    min_size     = var.core_blue_node_count
    max_size     = var.node_max_size
  }

  # During an update, replace at most this many nodes at a time
  update_config {
    max_unavailable = var.node_max_unavailable
  }

  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(local.common_tags, { Name = var.data_plane_blue })

  # The IAM permissions must exist before the nodes start and be removed only after
  # they are gone, otherwise EKS cannot clean up the EC2 instances and network cards.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

############################ Core services: GREEN node group ############################
resource "aws_eks_node_group" "core_data_plane_green" {
  count           = local.create_green ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.data_plane_green
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.standby_node_count # starting size only; the Cluster Autoscaler changes it later
    min_size     = var.standby_node_count
    max_size     = var.node_max_size
  }

  # During an update, replace at most this many nodes at a time
  update_config {
    max_unavailable = var.node_max_unavailable
  }

  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(local.common_tags, { Name = var.data_plane_green })

  # The IAM permissions must exist before the nodes start and be removed only after
  # they are gone, otherwise EKS cannot clean up the EC2 instances and network cards.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

############################ ML services: BLUE node group ############################
resource "aws_eks_node_group" "ml_data_plane_blue" {
  count           = local.create_blue ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.ml_data_plane_blue
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.standby_node_count # starting size only; the Cluster Autoscaler changes it later
    min_size     = var.standby_node_count
    max_size     = var.node_max_size
  }

  # Taint: only pods that tolerate it (ML inference) may run on these nodes
  taint {
    key    = var.ml_taint_key
    value  = var.ml_taint_value
    effect = "NO_SCHEDULE"
  }

  # During an update, replace at most this many nodes at a time
  update_config {
    max_unavailable = var.node_max_unavailable
  }

  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(local.common_tags, { Name = var.ml_data_plane_blue })

  # The IAM permissions must exist before the nodes start and be removed only after
  # they are gone, otherwise EKS cannot clean up the EC2 instances and network cards.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

############################ ML services: GREEN node group ############################
resource "aws_eks_node_group" "ml_data_plane_green" {
  count           = local.create_green ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = var.ml_data_plane_green
  node_role_arn   = aws_iam_role.eks_fintech_worker_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.standby_node_count # starting size only; the Cluster Autoscaler changes it later
    min_size     = var.standby_node_count
    max_size     = var.node_max_size
  }

  # Taint: only pods that tolerate it (ML inference) may run on these nodes
  taint {
    key    = var.ml_taint_key
    value  = var.ml_taint_value
    effect = "NO_SCHEDULE"
  }

  # During an update, replace at most this many nodes at a time
  update_config {
    max_unavailable = var.node_max_unavailable
  }

  lifecycle {
    create_before_destroy = true

    # desired_size is managed by the Cluster Autoscaler at runtime (it scales between
    # min_size and max_size). Terraform only uses desired_size when the group is first
    # created and never resets it afterwards, so a push cannot remove busy nodes.
    # To force more nodes, raise min_size instead.
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(local.common_tags, { Name = var.ml_data_plane_green })

  # The IAM permissions must exist before the nodes start and be removed only after
  # they are gone, otherwise EKS cannot clean up the EC2 instances and network cards.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

############################ Update local kubeconfig after cluster creation ############################
# Runs `aws eks update-kubeconfig` on the machine that applies Terraform, so kubectl works right away.
# Re-runs automatically if the cluster is recreated (new endpoint).
resource "terraform_data" "update_kubeconfig" {
  triggers_replace = [aws_eks_cluster.eks_control_plane.endpoint]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks_control_plane.name} --region ${var.region}"
  }

  depends_on = [aws_eks_cluster.eks_control_plane]
}
