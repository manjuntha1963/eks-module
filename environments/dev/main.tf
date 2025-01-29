module "eks_dev" {
  source = "../../modules/eks"

  environment     = "dev"
  cluster_name    = "myapp"
  cluster_version = "1.27"
  instance_types  = ["t3.small"]
  desired_size    = 2
  min_size        = 1
  max_size        = 3

  tags = {
    Project = "myapp"
  }
}
