# Create VPC (if enabled)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  create_vpc = var.create_vpc

  name = "${var.cluster_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

locals {
  vpc_id             = var.create_vpc ? module.vpc.vpc_id : var.vpc_id
  cluster_subnet_ids = var.create_vpc ? module.vpc.private_subnets : var.cluster_subnet_ids
  node_subnet_ids    = var.create_vpc ? module.vpc.private_subnets : var.node_subnet_ids
}

# Create EKS Cluster and Node Groups
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.cluster_name}-${var.environment}"
  cluster_version = var.cluster_version

  vpc_id                   = local.vpc_id
  subnet_ids               = local.cluster_subnet_ids

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = true
  cluster_enabled_log_types       = var.cluster_enabled_log_types

  eks_managed_node_groups = {
    default = {
      name            = "node-${var.environment}"
      instance_types  = var.instance_types
      subnet_ids      = local.node_subnet_ids
      min_size        = var.min_size
      max_size        = var.max_size
      desired_size    = var.desired_size
      capacity_type   = "ON_DEMAND"

      tags = merge(var.tags, {
        Environment = var.environment
      })
    }
  }

  tags = merge(var.tags, {
    Environment = var.environment
  })
}
