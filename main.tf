
provider "aws" {
    region = "ap-south-1"
}

module "vpc_creation"{
    source = "./vpc"
}

module "ec2_creation"{
    source = "./ec2"
    vpc_id = module.vpc_creation.vpc_id
    public_subnet_id=module.vpc_creation.public_subnet_id
    my_eip=module.vpc_creation.my_eip
} 

