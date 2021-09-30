#vpc, cidr 생성
resource "aws_vpc" "vpc-lsi-tfdemo-tokyo" { 
    cidr_block = "10.80.0.0/16"
    tags = {
        Name = "vpc-lsi-tfdemo-tokyo"
    }
}

#Internet Gateway 
resource "aws_internet_gateway" "igw-lsi-tfdemo-tokyo" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id #어떤 vpc와 연결할지 결정
    tags = {Name = "igw-lsi-tfdemo-tokyo"}
  
}

#Nat gateway가 사용할 Elastic IP
resource "aws_eip" "tfdemo_nat_eip" {
    vpc = true
}

#subnet 생성
resource "aws_subnet" "snet-lsi-tfdemo-tokyo-web-prd-az-a" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    cidr_block = "10.80.30.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = true
    tags = { Name = "snet-lsi-tfdemo-tokyo-web-prd-az-a"}
}

resource "aws_subnet" "snet-lsi-tfdemo-tokyo-app-prd-az-a" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    cidr_block = "10.80.60.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = false
    tags = { Name = "snet-lsi-tfdemo-tokyo-app-prd-az-a"}
}

resource "aws_subnet" "snet-lsi-tfdemo-tokyo-db-prd-az-a" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    cidr_block = "10.80.90.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = false
    tags = { Name = "snet-lsi-tfdemo-tokyo-db-prd-az-a"}
}

#NAT Gateway 
resource "aws_nat_gateway" "nat-lsi-tfdemo-tokyo" {
    allocation_id = aws_eip.tfdemo_nat_eip.id
    subnet_id = aws_subnet.snet-lsi-tfdemo-tokyo-web-prd-az-a.id

    tags = {
        Name = "nat-lsi-tfdemo-tokyo"
    }
}

#routing table 생성
resource "aws_route_table" "rt-lsi-tfdemo-tokyo-web-pub-prd" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-lsi-tfdemo-tokyo.id
        
    }

    tags = { Name = "rt-lsi-tfdemo-tokyo-web-pub-prd"}
}

resource "aws_route_table" "rt-lsi-tfdemo-tokyo-app-pri-prd" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-lsi-tfdemo-tokyo.id
    }

    tags = { Name = "rt-lsi-tfdemo-tokyo-app-pri-prd"}
}

resource "aws_route_table" "rt-lsi-tfdemo-tokyo-db-pri-prd" {
    vpc_id = aws_vpc.vpc-lsi-tfdemo-tokyo.id
    tags = { Name = "rt-lsi-tfdemo-tokyo-db-pri-prd"}
  
}

#Routing Table - subnet 연결
resource "aws_route_table_association" "tf-routing-web" {
  subnet_id = aws_subnet.snet-lsi-tfdemo-tokyo-web-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-tokyo-web-pub-prd.id
}

resource "aws_route_table_association" "tf-routing-app" {
  subnet_id = aws_subnet.snet-lsi-tfdemo-tokyo-app-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-tokyo-app-pri-prd.id
}

resource "aws_route_table_association" "tf-routing-db" {
  subnet_id = aws_subnet.snet-lsi-tfdemo-tokyo-db-prd-az-a.id
  route_table_id = aws_route_table.rt-lsi-tfdemo-tokyo-db-pri-prd.id
}

