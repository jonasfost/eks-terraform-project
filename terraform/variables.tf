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
variable "name" {
  type    = string
  default = "knote"
}

############# CLuster VErsion Variable ################

variable "cluster_version" {
  type    = string
  default = "1.28"
}
########## REgion Variable ###########################
variable "region" {
  type    = string
  default = "us-east-2"
}

################## Instance Type variable ####################

variable "instance_type" {
  type    = string
  default = "t3.large"
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
