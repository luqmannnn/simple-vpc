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
  enable_nat_gateway      = true
  one_nat_gateway_per_az  = true

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
  enable_nat_gateway      = true
  one_nat_gateway_per_az  = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Created_by  = "Admin"
    Cohort      = "CE11"
  }
}

module "vpc_coaching" {
  source  = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.useast1
  }

  version = "5.16.0"
  name    = "ce11-coaching7-shared-vpc"

  cidr            = "10.0.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "ce11-coaching7-shared-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc_coaching.vpc_id
  subnets         = module.vpc_coaching.public_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "web_app" {
  load_balancer_arn = module.alb.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_security_group" "alb" {
  name_prefix = "alb"
  description = "Allow web inbound traffic and all outbound traffic through the ALB"
  vpc_id      = module.vpc_coaching.vpc_id

  tags = {
    Name = "alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv6" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}