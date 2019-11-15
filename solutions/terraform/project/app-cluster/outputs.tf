output "repository_url" {
  value = module.registry.repository_url
}

output "cluster_name" {
  value = module.app_cluster.cluster_name
}

output "task_family" {
  value = module.app_cluster.task_family
}

output "service_name" {
  value = module.app_cluster.service_name
}
