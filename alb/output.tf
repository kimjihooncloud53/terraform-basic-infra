output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "web_target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}