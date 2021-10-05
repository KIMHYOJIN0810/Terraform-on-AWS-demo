
#target group
resource "aws_alb_target_group" "lsi-tfdemo-tg-prd-hjkim" {
  name     = "lsi-tfdemo-tg-prd-hjkim"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-lsi-tfdemo-sin.id
  health_check {
    interval            = 30
    path                = "/"
    timeout             = 29
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    "Name" = "lsi-tfdemo-tg-prd-hjkim"
  }
}

#alb생성
resource "aws_alb" "tfdemo-app-prd-hjkim-alb" {
  name               = "tfdemo-app-prd-hjkim-alb"
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = 60
  security_groups    = [aws_security_group.lsi-tfdemo-alb-prd-sg.id]
  subnets = [
    aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-a.id,
    aws_subnet.snet-lsi-tfdemo-sin-web-prd-az-c.id
  ]
  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "tfdemo-app-prd-hjkim-alb"
  }
}


#alb listener
resource "aws_alb_listener" "tfdemo-alb-listenr-hjkim" {
  load_balancer_arn = aws_alb.tfdemo-app-prd-hjkim-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.lsi-tfdemo-tg-prd-hjkim.arn
  }

}

#alb targetgroup attachment
resource "aws_alb_target_group_attachment" "tf-attachment-a" {
  target_group_arn = aws_alb_target_group.lsi-tfdemo-tg-prd-hjkim.arn
  target_id        = aws_instance.lsi-tfdemo-app-prd-a-hjkim.id
  port             = 80

}

resource "aws_alb_target_group_attachment" "tf-attachment-c" {
  target_group_arn = aws_alb_target_group.lsi-tfdemo-tg-prd-hjkim.arn
  target_id        = aws_instance.lsi-tfdemo-app-prd-c-hjkim.id
  port             = 80

}