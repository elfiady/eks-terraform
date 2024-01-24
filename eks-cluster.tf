module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "~> 19.16"
  cluster_name    = local.cluster_name
  cluster_version = "1.28"
  
  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  create_node_security_group    = false

  eks_managed_node_groups = {
    default = {
      instance_types       = ["m5.large"]
      force_update_version = true
      release_version      = var.ami_release_version

      min_size     = 3
      max_size     = 6
      desired_size = 3
      
      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        workshop-default = "yes"
      }
    }
  }
}
