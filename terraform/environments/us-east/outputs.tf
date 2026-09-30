output "vpc_cidr" {
  value = module.k8s_cluster.vpc_cidr
}

output "iam_user_secret_access_key" {
  value     = module.k8s_cluster.iam_user_secret_access_key
  sensitive = true
}
# output "current_state" {
#   value = module.k8s_cluster.current_state
# }