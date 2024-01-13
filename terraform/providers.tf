terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.12.0"
    }
  }
}

###################################################
###### Configure the AWS, Kubernetes Provider #####
###################################################

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  # host                   = data.aws_eks_cluster.cluster.endpoint
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
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