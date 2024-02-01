################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "app.terraform.io/jonasfost/eks/aws"
  version = "1.1.1"

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
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.instance_type]

    attach_cluster_primary_security_group = true
    # vpc_security_group_ids                = [aws_security_group.additional.id]
    # iam_role_additional_policies = {
    #   additional = aws_iam_policy.additional.arn
    # }
  }

  eks_managed_node_groups = {
    prod-knote-node1 = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = [var.instance_type]
      capacity_type  = "SPOT"
      labels = {
        Environment = "${var.environment}-node1"
      }
    }
    prod-knote-node2 = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = [var.instance_type]
      capacity_type  = "SPOT"
      labels = {
        Environment = "${var.environment}-node2"
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

  # node_security_group_additional_rules = {
  #   ingress_allow_access_from_control_plane = {
  #     type                          = "ingress"
  #     protocol                      = "tcp"
  #     from_port                     = 9443
  #     to_port                       = 9443
  #     source_cluster_security_group = true
  #     description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  #   }
  # }

  iam_role_additional_policies = {
    additional = aws_iam_policy.worker_policy.arn
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

  cluster_tags = {
    Name         = "${var.name}-eks"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}

resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy-${var.name}-eks"
  description = "Worker policy for the ALB Ingress"

  policy = file("iam_policy.json")
}


resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.worker_policy.arn
  role       = each.value.iam_role_name
}

resource "helm_release" "ingress" {
  name      = "ingress"
  namespace = "kube-system"
  chart     = "aws-load-balancer-controller"
  # repository = "https://aws.github.io/eks-charts"
  repository = "https://github.com/aws/eks-charts"
  version    = "1.1.6"

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "clusterName"
    value = "${var.name}-eks"
    # value = data.aws_eks_cluster.cluster.name
    # value = module.eks.cluster_name
  }
}