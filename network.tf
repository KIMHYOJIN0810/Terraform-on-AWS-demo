#vpc, cidr 생성
resource "aws_vpc" "vpc-lsi-tfdemo-sin" {
  cidr_block = "10.80.0.0/16"
  tags = {
    Name = "vpc-lsi-tfdemo-sin"
  }
}

#Internet Gateway 
resource "aws_internet_gateway" "igw-lsi-tfdemo-sin" {
  vpc_id = aws_vpc.vpc-lsi-tfdemo-sin.id #어떤 vpc와 연결할지 결정
  tags   = { Name = "igw-lsi-tfdemo-sin" }

}

#Nat gateway가 사용할 Elastic IP
resource "aws_eip" "tfdemo_nat_eip" {
  vpc = true
}

#subnet 생성
resource "aws_subnet" "snet-lsi-tfdemo-sin-web-prd-az-a" {
  vpc_id                  = aws_vpc.vpc-lsi-tfdemo-sin.id
  cidr_block              = "10.80.30.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "snet-lsi-tfdemo-sin-web-prd-az-a" }
}
resource "aws_subnet" "snet-lsi-tfdemo-sin-web-prd-az-c" {
  vpc_id                  = aws_vpc.vpc-lsi-tfdemo-sin.id
  cidr_block              = "10.80.35.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true
  tags                    = { Name = "snet-lsi-tfdemo-sin-web-prd-az-c" }
}

resource "aws_subnet" "snet-lsi-tfdemo-sin-app-prd-az-a" {
  vpc_id                  = aws_vpc.vpc-lsi-tfdemo-sin.id
  cidr_block              = "10.80.60.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags                    = { Name = "snet-lsi-tfdemo-sin-app-prd-az-a" }
}
resource "aws_subnet" "snet-lsi-tfdemo-sin-app-prd-az-c" {
  vpc_id                  = aws_vpc.vpc-lsi-tfdemo-sin.id
  cidr_block              = "10.80.65.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = false
  tags                    = { Name = "snet-lsi-tfdemo-sin-app-prd-az-c" }
}

resource "aws_subnet" "snet-lsi-tfdemo-sin-db-prd-az-a" {
  vpc_id                  = aws_vpc.vpc-lsi-tfdemo-sin.id
  cidr_block              = "10.80.90.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags                    = { Name = "snet-lsi-tfdemo-sin-db-prd-az-a" }
}

#NAT Gateway 
resource "aws_nat_gateway" "nat-lsi-tfdemo-sin" {
  allocation_id = aws_eip.tfdemo_nat_eip.id
  subnet_id     = aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-a.id

  tags = {
    Name = "nat-lsi-tfdemo-sin"
  }
}

#routing table 생성
resource "aws_route_table" "rt-lsi-tfdemo-sin-web-pub-prd" {
  vpc_id = aws_vpc.vpc-lsi-tfdemo-sin.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-lsi-tfdemo-sin.id

  }

  tags = { Name = "rt-lsi-tfdemo-sin-web-pub-prd" }
}

resource "aws_route_table" "rt-lsi-tfdemo-sin-app-pri-prd" {
  vpc_id = aws_vpc.vpc-lsi-tfdemo-sin.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-lsi-tfdemo-sin.id
  }

  tags = { Name = "rt-lsi-tfdemo-sin-app-pri-prd" }
}

resource "aws_route_table" "rt-lsi-tfdemo-sin-db-pri-prd" {
  vpc_id = aws_vpc.vpc-lsi-tfdemo-sin.id
  tags   = { Name = "rt-lsi-tfdemo-sin-db-pri-prd" }

}

#Routing Table - subnet 연결
resource "aws_route_table_association" "tf-routing-web-a" {
  subnet_id      = aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-sin-web-pub-prd.id
}
resource "aws_route_table_association" "tf-routing-web-c" {
  subnet_id      = aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-c.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-sin-web-pub-prd.id
}
resource "aws_route_table_association" "tf-routing-app-a" {
  subnet_id      = aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-sin-app-pri-prd.id
}
resource "aws_route_table_association" "tf-routing-app-c" {
  subnet_id      = aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-c.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-sin-app-pri-prd.id
}

resource "aws_route_table_association" "tf-routing-db-a" {
  subnet_id      = aws_subnet.snet-lsi-tfdemo-sin-db-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-sin-db-pri-prd.id
}

