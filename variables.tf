variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Existing VPC ID (required if create_vpc = false)"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (if create_vpc = true)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks (if create_vpc = true)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks (if create_vpc = true)"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_subnet_ids" {
  description = "Existing subnet IDs for the EKS control plane (required if create_vpc = false)"
  type        = list(string)
  default     = null
}

variable "node_subnet_ids" {
  description = "Existing subnet IDs for worker nodes (required if create_vpc = false)"
  type        = list(string)
  default     = null
}

variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "cluster_enabled_log_types" {
  description = "List of control plane logs to enable"
  type        = list(string)
  default     = ["api", "audit"]
}

validation {
  condition     = var.create_vpc ? true : (var.vpc_id != null && var.cluster_subnet_ids != null && var.node_subnet_ids != null)
  error_message = "vpc_id, cluster_subnet_ids, and node_subnet_ids must be set if create_vpc is false."
}
