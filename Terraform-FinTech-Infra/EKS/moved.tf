# Keeps existing state when resource labels were renamed to snake_case.

moved {
  from = aws_eks_cluster.EKS-Control-Plane
  to   = aws_eks_cluster.eks_control_plane
}

moved {
  from = aws_iam_role.EKS-FinTech-Cluster-Role
  to   = aws_iam_role.eks_fintech_cluster_role
}

moved {
  from = aws_iam_role.EKS-FinTech-Worker-Node-Role
  to   = aws_iam_role.eks_fintech_worker_node_role
}

moved {
  from = aws_iam_role.Hassan-iam-role
  to   = aws_iam_role.hassan_iam_role
}

moved {
  from = aws_eks_access_entry.Hassan-devops-engineer-entry
  to   = aws_eks_access_entry.hassan_devops_engineer_entry
}

moved {
  from = aws_iam_role_policy_attachment.EKS_CLUSTER_POLICY_ATTACHMENT
  to   = aws_iam_role_policy_attachment.eks_cluster_policy_attachment
}

moved {
  from = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
  to   = aws_iam_role_policy_attachment.amazon_eks_worker_node_policy
}

moved {
  from = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  to   = aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
}

moved {
  from = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  to   = aws_iam_role_policy_attachment.amazon_eks_cni_policy
}

moved {
  from = aws_iam_user.Hassan
  to   = aws_iam_user.hassan
}

moved {
  from = aws_iam_user_policy.IAM_User_and_Role_attachment
  to   = aws_iam_user_policy.iam_user_and_role_attachment
}
