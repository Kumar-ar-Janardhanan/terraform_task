output "vpc_id" {
  value = module.vpc_creation.vpc_id
}

output "public_ip"{
  description = "Public IP of EC2 instance"
  value=module.ec2_creation.public_ip
}