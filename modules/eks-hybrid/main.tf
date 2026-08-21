module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-enterprise-eks"
  cluster_version = "1.30"
  

  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  eks_managed_node_groups = {
    linux_core = {
      min_size       = 2
      max_size       = 10
      desired_size   = 3
      instance_types = ["m6i.xlarge"]
      ami_type       = "AL2023_x86_64_STANDARD"
    }
    windows_workloads = {
      min_size       = 1
      max_size       = 5
      desired_size   = 2
      instance_types = ["m6i.2xlarge"]
      ami_type       = "WINDOWS_CORE_2022_x86_64"
    }
  }
}