resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-alb-sg"
  description = "${var.prefix}-alb-sg"
  vpc_id      = var.vpc_id
  
  tags = {
    "Name" = "${var.prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_security_group" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_lb_target_group" "web_target_group" {
  name = "${var.prefix}-web-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id

  tags = {
    "name"  = "${var.prefix}-web-tg"
  }
}

resource "aws_lb" "alb" {
  name = "${var.prefix}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [var.public_subnet_ids[0], var.public_subnet_ids[1]]

  tags = {
    "Name" = "${var.prefix}-alb"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}