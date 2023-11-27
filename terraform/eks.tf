################################################################################
# EKS Module
################################################################################

module "eks" {
  # source = "/home/cyber/repos/johny-class-devops/terraform/modules/eks"
  source  = "app.terraform.io/jonasfost/eks/aws"
  version = "1.0.3"

  cluster_name                   = "${var.name}-eks"
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t2.micro"]

    attach_cluster_primary_security_group = true
    # vpc_security_group_ids                = [aws_security_group.additional.id]
    # iam_role_additional_policies = {
    #   additional = aws_iam_policy.additional.arn
    # }
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
      labels = {
        Environment = var.environment
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }

      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_iam_user.user_name.arn
      username = data.aws_iam_user.user_name.user_name
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Name         = "${var.name}-eks"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}