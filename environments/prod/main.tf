module "eks_prod" {
  source = "../../modules/eks"

  environment        = "prod"
  cluster_name       = "myapp"
  cluster_version    = "1.27"
  instance_types     = ["m5.large"]
  desired_size       = 3
  min_size           = 3
  max_size           = 5
  create_vpc         = false
  vpc_id             = "vpc-12345678"
  cluster_subnet_ids = ["subnet-123", "subnet-456"]
  node_subnet_ids    = ["subnet-123", "subnet-456"]

  cluster_endpoint_public_access = false # Private endpoint

  tags = {
    Project = "myapp"
  }
}
