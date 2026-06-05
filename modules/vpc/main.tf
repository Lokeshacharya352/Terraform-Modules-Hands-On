

locals {
  common_tags = {
    Environment = var.environment
  }
}

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {

    Name = "${var.environment}-vpc"

    }
  )
}


resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet

  availability_zone = var.availability_zone

  tags = merge(local.common_tags, {

    Name = "${var.environment}-public-subnet"

    }

  )
  map_public_ip_on_launch = true

}


resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.main.id

  tags ={

    Name = "${var.environment}-igw"

    }
  
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {

    Name = "${var.environment}-public-rt"

    }
  )
  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.gw.id

  }
}

resource "aws_route_table_association" "public" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}

