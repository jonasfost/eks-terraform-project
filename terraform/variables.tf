############# Environment Variable #######################

variable "environment" {
  type    = string
  default = "prod"
}

############# Provisionner Variable #######################

variable "provisioner" {
  type    = string
  default = "Terraform"
}

############## VPC name Variable ###################
variable "vpc_name" {
  type    = string
  default = "knote-cluster-vpc"
}

############## EKS Name Variable ###################
variable "eks_name" {
  type    = string
  default = "knote-eks"
}

############# CLuster VErsion Variable ################

variable "cluster_version" {
  type    = string
  default = "1.27"
}
########## REgion Variable ###########################
variable "region" {
  type    = string
  default = "us-east-2"
}

################## Instance Type variable ####################

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

################## AMI Type variable ####################

variable "ami_type" {
  type    = string
  default = "AL2_x86_64"
}

################## EKS Addon Name  variable ####################

variable "addon_name" {
  type    = string
  default = "aws-ebs-csi-driver"
}

################## EKS Addon VErsion  variable ####################

variable "addon_version" {
  type    = string
  default = "v1.20.0-eksbuild.1"
}

#################### Key Pair Variable ########################

variable "key_pair_use2" {
  type    = string
  default = "main-us-east-2"
}
