# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  # cluster_name    = local.cluster_name
  cluster_name    = var.eks_name
  cluster_version = var.cluster_version

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = var.ami_type
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = [var.instance_type]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }

    two = {
      name           = "node-group-2"
      instance_types = [var.instance_type]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  cluster_tags = {
    Name         = "${var.eks_name}-cluster"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = var.addon_name
  addon_version            = var.addon_version
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}