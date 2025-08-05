module "vpc_useast1" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.useast1
  }

  name = "ce11-tf-vpc-${var.run_number}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  map_public_ip_on_launch = true
  enable_vpn_gateway      = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Created_by  = "Admin"
    Cohort      = "CE11"
  }
}

module "vpc_apsoutheast1" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.apsoutheast1
  }

  name = "ce10-tf-vpc-${var.run_number}"
  cidr = "10.1.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  map_public_ip_on_launch = true
  enable_vpn_gateway      = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Created_by  = "Admin"
    Cohort      = "CE11"
  }
}
