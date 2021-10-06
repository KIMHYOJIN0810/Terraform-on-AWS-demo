resource "aws_security_group" "lsi-tfdemo-web-prd-a-sg" {
  vpc_id      = aws_vpc.vpc-lsi-tfdemo-sin.id
  name        = "lsi-tfdemo-web-prd-a-sg"
  description = "lsi-tfdemo-web-prd-a-sg"
  ingress {
    from_port   = 22                   #인바운드 시작 포트
    to_port     = 22                   #인바운드 끝나는 포트
    protocol    = "tcp"                #사용할 프로토콜
    cidr_blocks = ["211.168.91.10/32"] #허용할 IP 범위
  }
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["211.168.91.10/32"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lsi-tfdemo-web-prd-a-sg" }

}

resource "aws_security_group" "lsi-tfdemo-app-prd-a-sg" {
  vpc_id      = aws_vpc.vpc-lsi-tfdemo-sin.id
  name        = "lsi-tfdemo-app-prd-a-sg"
  description = "lsi-tfdemo-app-prd-a-sg"
  ingress {
    from_port   = 80            #인바운드 시작 포트
    to_port     = 80            #인바운드 끝나는 포트
    protocol    = "tcp"         #사용할 프로토콜
    cidr_blocks = ["0.0.0.0/0"] #허용할 IP 범위
  }
  ingress {
    from_port   = 22                   #인바운드 시작 포트
    to_port     = 22                   #인바운드 끝나는 포트
    protocol    = "tcp"                #사용할 프로토콜
    cidr_blocks = ["211.168.91.10/32"] #허용할 IP 범위
  }
  ingress {
    from_port   = 22               #인바운드 시작 포트
    to_port     = 22               #인바운드 끝나는 포트
    protocol    = "tcp"            #사용할 프로토콜
    cidr_blocks = ["10.80.0.0/16"] #허용할 IP 범위
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lsi-tfdemo-app-prd-a-sg" }

}

resource "aws_security_group" "lsi-tfdemo-db-prd-a-sg" {
  vpc_id      = aws_vpc.vpc-lsi-tfdemo-sin.id
  name        = "lsi-tfdemo-db-prd-a-sg"
  description = "lsi-tfdemo-db-prd-a-sg"
  ingress {
    from_port       = 3306  #인바운드 시작 포트
    to_port         = 3306  #인바운드 끝나는 포트
    protocol        = "tcp" #사용할 프로토콜
    security_groups = [aws_security_group.lsi-tfdemo-app-prd-a-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lsi-tfdemo-db-prd-a-sg" }

}

resource "aws_security_group" "lsi-tfdemo-alb-prd-sg" {
  vpc_id      = aws_vpc.vpc-lsi-tfdemo-sin.id
  name        = "lsi-tfdemo-alb-prd-sg"
  description = "lsi-tfdemo-alb-prd-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lsi-tfdemo-alb-prd-sg" }

}