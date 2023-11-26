terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#######################################
###### Configure the AWS Provider #####
#######################################

provider "aws" {
  region = var.region
}

####################################################
##### Terraform Cloud For Remote State #############
####################################################

terraform {
  cloud {
    organization = "jonasfost"

    workspaces {
      name = "knote-eks-prod"
    }
  }
}