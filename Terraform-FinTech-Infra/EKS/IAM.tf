###############################################EKS-Cluster-Role###############################################
resource "aws_iam_role" "EKS-FinTech-Cluster-Role" {
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
resource "aws_iam_role_policy_attachment" "EKS_CLUSTER_POLICY_ATTACHMENT" {
  role       = aws_iam_role.EKS-FinTech-Cluster-Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

###############################################EKS-Worker-Node-Role############################################################
resource "aws_iam_role" "EKS-FinTech-Worker-Node-Role" {
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
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.EKS-FinTech-Worker-Node-Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.EKS-FinTech-Worker-Node-Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.EKS-FinTech-Worker-Node-Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

##################################Creating an New IAM User#############################################
resource "aws_iam_user" "Hassan" {
  name = "Hassan"
  tags = {
    Name = "Hassan"
  }
}

##################################Creating an New IAM Role for the User#############################################
resource "aws_iam_role" "Hassan-iam-role" {
  name = "Hassan-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
  AWS = aws_iam_user.Hassan.arn } }, ] })
  tags = { Name = "Hassan-iam-role" }
}

##################################Attaching IAM User with IAM Role#############################################
resource "aws_iam_user_policy" "IAM_User_and_Role_attachment" {
  name = "IAM_User_and_Role_attachment"
  user = aws_iam_user.Hassan.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
  Resource = aws_iam_role.Hassan-iam-role.arn }, ] })
}
