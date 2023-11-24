################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name

  cidr = local.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  public_subnets  = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  # name = "${var.environment}-vpc"
  # cidr = local.vpc_cidr

  # azs             = local.azs
  # private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  # public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  # manage_default_network_acl    = false
  # manage_default_route_table    = false
  # manage_default_security_group = false

  # enable_dns_hostnames = true
  # enable_dns_support   = true

  # enable_nat_gateway = true
  # single_nat_gateway = true

  # #### VPC Tags
  # vpc_tags = {
  #   Name         = "${var.environment}-vpc"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # #### Public Subnets Tags
  # public_subnet_tags = {
  #   Name         = "${var.environment}-public-subnet"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### Public Route Table Tags
  # public_route_table_tags = {
  #   Name         = "${var.environment}-public-rt"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### Private Subnets Tags
  # private_subnet_tags = {
  #   Name         = "${var.environment}-private-subnet"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### Private Route Table Tags
  # private_route_table_tags = {
  #   Name         = "${var.environment}-private-rt"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### Internet Gateway Tags
  # igw_tags = {
  #   Name         = "${var.environment}-igw"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### Nat Gateway tags
  # nat_gateway_tags = {
  #   Name         = "${var.environment}-ngw"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }

  # ### EIP Tags
  # nat_eip_tags = {
  #   Name         = "${var.environment}-eip"
  #   Environment  = var.environment
  #   Provisionner = var.provisioner
  # }
}