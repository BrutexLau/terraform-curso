resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "vpc_virginia-${local.sufix}"
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
  availability_zone       = "us-east-1a" # fuerza una AZ donde sí existe t3.micro
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public_Subnet-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_virginia.id
  cidr_block        = var.subnets[1]
  availability_zone = "us-east-1a" # misma AZ
  tags = {
    "Name" = "Private_Subnet-${local.sufix}"
  }
}
// Para poder llegar desde internet a nuestas instancias EC2
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "publi crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}
//Security Group
resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id
  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }

  tags = {
    Name = "Public Instance SG-${local.sufix}"
  }
}

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
#   security_group_id = aws_security_group.sg_public_instance.id
#   cidr_ipv4         = var.sg_ingress_cidr
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }
# resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
#   security_group_id = aws_security_group.sg_public_instance.id
#   cidr_ipv4         = var.sg_ingress_cidr
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }
# resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
#   security_group_id = aws_security_group.sg_public_instance.id
#   cidr_ipv4         = var.sg_ingress_cidr
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_public_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

module "mybucket" {
  source      = "./modulos/s3"
  bucket_name = "nombreunico9087623675"
}

output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}

# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage

# module "terraform_state_backend" {
#   source = "cloudposse/tfstate-backend/aws"
#   # Cloud Posse recommends pinning every module to a specific version
#   version     = "1.6.0"
#   namespace   = "example"
#   stage       = "prod"
#   name        = "terraformufgjdv798987235655802"
#   environment = "us-east-1"
#   attributes  = ["state"]

#   terraform_backend_config_file_path = "."
#   terraform_backend_config_file_name = "backend.tf"
#   force_destroy                      = false
# }

