output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group IDs attached to the cluster"
  value       = module.eks.cluster_security_group_id
}

output "node_group_arn" {
  description = "ARN of the managed node group"
  value       = module.eks.eks_managed_node_groups["default"].arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = local.vpc_id
}
