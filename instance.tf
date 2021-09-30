

# resource "aws_instance" "lsi-tfdemo-web-pub-a-hjkim" {
#   ami ="ami-0df99b3a8349462c6"
#   availability_zone = "ap-southeast-1a"
#   instance_type = "t2.micro"
#   key_name = aws_key_pair.tfdemo-keypair.tfdemo-key

#   vpc_security_group_ids = [
#       "aws_security_group.lsi-tfdemo-web-prd-a-sg.id"
#   ]

#   subnet_id = "aws_subnet.snet-lsi-tfdemo-tokyo-web-prd-az-a.id"
#   associate_public_ip_address = true

#   tags = {
#       Name = "lsi-tfdemo-web-pub-a-hjkim"
#   }
# }


resource "aws_instance" "lsi-tfdemo-app-pub-a-hjkim" {
  ami ="ami-0896fab72d64cba59"
  availability_zone = "ap-southeast-1a"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
      "aws_security_group.lsi-tfdemo-app-prd-a-sg.id"
  ]

  subnet_id = "aws_subnet.snet-lsi-tfdemo-tokyo-app-prd-az-a.id"


  tags = {
      Name = "lsi-tfdemo-app-pub-a-hjkim"
  }
}

