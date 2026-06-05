module "vpc" {
  environment = var.environment

  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnet = var.public_subnet

  availability_zone = var.availability_zone

}

module "sg" {

  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

  allowed_ports = var.allowed_ports

}

module "ec2" {

  source = "./modules/ec2"

  environment = var.environment

  ami_id = var.ami_id

  instance_type = var.instance_type

  subnet_id = module.vpc.subnet_id

  security_group_id = module.sg.security_group_id
 
}