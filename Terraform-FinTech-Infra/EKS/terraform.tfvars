region                           = "us-east-1"
cluster_name                     = "FinTech-Cluster"
cluster_version                  = "1.36"
env                              = "Production"
endpoint_private_access          = true
endpoint_public_access           = true
oidc_client_id_list              = ["sts.amazonaws.com"]
node_color                       = "both"
data_plane_blue                  = "Core_Services_Blue_Node_Group"
data_plane_green                 = "Core_Services_Green_Node_Group"
ml_data_plane_blue               = "Machine_Learning_Blue_Node_Group"
ml_data_plane_green              = "Machine_Learning_Green_Node_Group"
cluster_autoscaler_chart_version = "9.60.0"
cluster_autoscaler_image_tag     = "v1.36.2"
cluster_admin_arns = [
  "arn:aws:iam::747240980649:root",
  "arn:aws:iam::747240980649:role/FinTech_Enterprise_Project_GithubActions_OIDC_Role",
]
