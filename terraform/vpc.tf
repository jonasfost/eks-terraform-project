################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = var.vpc_name

  cidr = local.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  public_subnets  = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  enable_dns_support            = true

  #### VPC Tags
  vpc_tags = {
    Name         = var.vpc_name
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  #### Public Subnets Tags
  public_subnet_tags = {
    Name                     = "${var.name}-public-subnet"
    Environment              = var.environment
    Provisionner             = var.provisioner
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/knote-eks" = "owned"
  }

  ### Public Route Table Tags
  public_route_table_tags = {
    Name         = "${var.name}-public-rt"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Private Subnets Tags
  private_subnet_tags = {
    Name                              = "${var.name}-private-subnet"
    Environment                       = var.environment
    Provisionner                      = var.provisioner
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/knote-eks" = "owned"
  }

  ### Private Route Table Tags
  private_route_table_tags = {
    Name         = "${var.name}-private-rt"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Internet Gateway Tags
  igw_tags = {
    Name         = "${var.name}-igw"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Nat Gateway tags
  nat_gateway_tags = {
    Name         = "${var.name}-ngw"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### EIP Tags
  nat_eip_tags = {
    Name         = "${var.name}-eip"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}