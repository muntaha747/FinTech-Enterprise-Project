###############################################EKS-Cluster-Role###############################################
resource "aws_iam_role" "eks_fintech_cluster_role" {
  name = "${var.cluster_name}-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.cluster_name}-Role"
  }
}

###############################################EKS-CLUSTER-ROLE-POLICY-ATTACHMENT###############################################
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_fintech_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

###############################################EKS-Worker-Node-Role############################################################
resource "aws_iam_role" "eks_fintech_worker_node_role" {
  name = "${var.cluster_name}-Worker-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.cluster_name}-Worker-Role"
  }
}

###############################################EKS-Worker-Node-Role-Attachment###############################################
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

##################################Creating an New IAM User#############################################
resource "aws_iam_user" "hassan" {
  name = "Hassan"
  tags = {
    Name = "Hassan"
  }
}

##################################Creating an New IAM Role for the User#############################################
resource "aws_iam_role" "hassan_iam_role" {
  name = "Hassan-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
  AWS = aws_iam_user.hassan.arn } }, ] })
  tags = { Name = "Hassan-iam-role" }
}

##################################Attaching IAM User with IAM Role#############################################
resource "aws_iam_user_policy" "iam_user_and_role_attachment" {
  name = "IAM_User_and_Role_attachment"
  user = aws_iam_user.hassan.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
  Resource = aws_iam_role.hassan_iam_role.arn }, ] })
}
