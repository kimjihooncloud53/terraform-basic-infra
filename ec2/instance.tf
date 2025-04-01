resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}-web-sg"
  description = "${var.prefix}-web-sg"
  vpc_id      = var.vpc_id
  
  tags = {
    "Name" = "${var.prefix}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_security_group" {
  security_group_id = aws_security_group.web_sg.id

  referenced_security_group_id = var.alb_sg_id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "web_instance" {
  ami = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]
  associate_public_ip_address = false
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<EOF
#!/bin/bash
sudo su
yum install httpd -y

systemctl start httpd
systemctl enable httpd
systemctl restart httpd

touch /var/www/html/index.html
chmod +x /var/www/html/index.html
echo "Welcome to Terraform" | sudo tee /var/www/html/index.html
EOF

  tags = {
    "Name" = "${var.prefix}-web-instance"
  }
}