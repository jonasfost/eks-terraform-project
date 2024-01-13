data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

################ Route53 Data Source Lookup ###############
data "aws_route53_zone" "johnyfoster_zone" {
  name = "johnyfoster.com."
}

data "aws_iam_user" "user_name" {
  user_name = "jfotso"
}

data "aws_eks_cluster" "cluster" {
  # name = module.eks.cluster_name
  name = "${var.name}-eks"
}

data "aws_eks_cluster_auth" "cluster" {
  # name = module.eks.cluster_name
  name = "${var.name}-eks"
}