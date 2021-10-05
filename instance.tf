
#bastion_server 생성
resource "aws_instance" "lsi-tfdemo-web-prd-a-hjkim" {
  ami               = "ami-0534dbc0328408111"
  availability_zone = "ap-southeast-1a"
  instance_type     = "t2.micro"
  key_name          = "lsitc-sin-demo-prod"

  vpc_security_group_ids = [
    aws_security_group.lsi-tfdemo-web-prd-a-sg.id

  ]

  subnet_id                   = aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-a.id
  associate_public_ip_address = true


  tags = {
    Name = "lsi-tfdemo-web-prd-a-hjkim"
  }
}


#app_server 생성
resource "aws_instance" "lsi-tfdemo-app-prd-a-hjkim" {
  ami               = "ami-0d058fe428540cd89"
  availability_zone = "ap-southeast-1a"
  instance_type     = "t2.micro"
  key_name          = "lsitc-sin-demo-prod"

  vpc_security_group_ids = [
    aws_security_group.lsi-tfdemo-app-prd-a-sg.id

  ]

  subnet_id                   = aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-a.id
  associate_public_ip_address = false


  tags = {
    Name = "lsi-tfdemo-app-prd-a-hjkim"
  }
}

resource "aws_instance" "lsi-tfdemo-app-prd-c-hjkim" {
  ami               = "ami-0d058fe428540cd89"
  availability_zone = "ap-southeast-1c"
  instance_type     = "t2.micro"
  key_name          = "lsitc-sin-demo-prod"

  vpc_security_group_ids = [
    aws_security_group.lsi-tfdemo-app-prd-a-sg.id

  ]

  subnet_id                   = aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-c.id
  associate_public_ip_address = false


  tags = {
    Name = "lsi-tfdemo-app-prd-c-hjkim"
  }
}


#aws_db_subnet_group 생성
resource "aws_db_subnet_group" "subnetgroup-lsi-dfdemo-sin-prd" {
  name       = "subnetgroup-lsi-dfdemo-sin-prd"
  subnet_ids = [aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-a.id, aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-a.id, aws_subnet.snet-lsi-tfdemo-sin-db-prd-az-a.id, aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-c.id, aws_subnet.snet-lsi-tfdemo-sin-app-prd-az-c.id]

  tags = {
    Name = "subnetgroup-lsi-dfdemo-sin-prd"
  }
}

#rds 생성
resource "aws_db_instance" "lsi-tfdemo-db-prd-a-hjkim" {
  allocated_storage    = 50
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.small"
  username             = "admindb"
  password             = "wels!2021350"
  name                 = "tfdemo"
  db_subnet_group_name = aws_db_subnet_group.subnetgroup-lsi-dfdemo-sin-prd.id
  skip_final_snapshot  = true
  vpc_security_group_ids = [
    aws_security_group.lsi-tfdemo-db-prd-a-sg.id

  ]

}
