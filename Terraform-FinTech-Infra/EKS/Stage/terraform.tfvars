# terraform.tfvars: the VALUES for the Stage EKS stack.

############################ General ############################
region       = "us-east-1"
project_name = "FinTech-Enterprise-Project"
stack_name   = "eks"
environment  = "Stage"

############################ Networking lookup ############################
# Must match Networking/Stage: its backend.tf (bucket + key) and the App VPC name in its terraform.tfvars
networking_state_bucket = "fintech-project-statefile-bucket"
networking_state_key    = "cloudnetworking/stage/networking.tfstate"
vpc_name                = "FinTech-App-Stage"

############################ Control plane ############################
cluster_name            = "FinTech-Cluster-Stage"
cluster_version         = "1.36"
endpoint_private_access = true
endpoint_public_access  = true
cluster_admin_arns = [
  "arn:aws:iam::747240980649:root",
  "arn:aws:iam::747240980649:role/FinTech_Enterprise_Project_GithubActions_OIDC_Role",
]
devops_user_name = "Hassan-Stage"

############################ Node groups ############################
# blue = only blue groups, green = only green groups, both = all four groups
node_color          = "blue"
data_plane_blue     = "Core_Services_Blue_Node_Group"
data_plane_green    = "Core_Services_Green_Node_Group"
ml_data_plane_blue  = "Machine_Learning_Blue_Node_Group"
ml_data_plane_green = "Machine_Learning_Green_Node_Group"

############################ Cluster Autoscaler ############################
cluster_autoscaler_chart_version = "9.60.0"
cluster_autoscaler_image_tag     = "v1.36.2" # keep in step with cluster_version (1.36 -> v1.36.x)
