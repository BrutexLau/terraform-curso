resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "vpc_virginia"
  }
}

# resource "aws_vpc" "vpc_virginia" {
#   cidr_block = var.virginia_cidr
#   tags = {
#     Name = "VPC_VIRGINIA"
#     name = "prueba"
#     env = "Dev"
#   }
# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id = aws_vpc.vpc_virginia.id
#   cidr_block = var.public_subnet
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id = aws_vpc.vpc_virginia.id
#   cidr_block = var.private_subnet
# }


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public_Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "Private_Subnet"
  }
}