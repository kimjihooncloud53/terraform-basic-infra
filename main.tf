module "vpc" {
  source = "./vpc"

  prefix = var.prefix
  vpc_cidr = var.vpc_cidr
  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  availability_zones = data.aws_availability_zones.current_azs.names
}

module "alb" {
  source = "./alb"

  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  depends_on = [ module.vpc ]
}

module "ec2" {
  source = "./ec2"

  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  ami_id = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  private_subnet_ids = module.vpc.private_subnet_ids
  alb_sg_id = module.alb.alb_sg_id
  web_target_group_arn = module.alb.web_target_group_arn
  
  depends_on = [ module.alb ]
}