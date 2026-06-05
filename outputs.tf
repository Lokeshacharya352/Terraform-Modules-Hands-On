output "vpc_id" {

  value = module.vpc.vpc_id

}

output "subnet_id" {

  value = module.vpc.subnet_id

}

output "security_group_id" {

  value = module.sg.security_group_id

}

output "instance_id" {

  value = module.ec2.instance_id

}

output "public_ip" {

  value = module.ec2.public_ip

}