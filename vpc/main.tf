
// Create the VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames=true
}

// Create the public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "ap-south-1a"
    map_public_ip_on_launch = true
}

// Create the private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "ap-south-1b"
    map_public_ip_on_launch = false
}

// Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
}


// Attach the internet gateway to the VPC
//resource "aws_internet_gateway_attachment" "my_vpc_attachment" {
  //  vpc_id             = aws_vpc.my_vpc.id
    //internet_gateway_id = aws_internet_gateway.my_igw.id
//}

// Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
}

// Create a route for the public subnet to the internet gateway
resource "aws_route" "public_route" {
    route_table_id         = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.my_igw.id
}

// Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

// Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.my_vpc.id
}

// Create a route for the private subnet to a NAT gateway (or other outbound gateway)
// Replace the NAT gateway ID with the appropriate ID for your environment
resource "aws_route" "private_route" {
        route_table_id         = aws_route_table.private_route_table.id
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}

// Create a NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
        allocation_id = aws_eip.my_nat_eip.id
        subnet_id     = aws_subnet.public_subnet.id
}

// Create an Elastic IP for the NAT Gateway
resource "aws_eip" "my_nat_eip" {
        domain= "vpc"
}
//instance eip_assoc
resource "aws_eip" "my_eip" {
        domain= "vpc"
}

// Associate the private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}
