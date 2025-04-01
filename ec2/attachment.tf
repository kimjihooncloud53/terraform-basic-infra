resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  target_group_arn = var.web_target_group_arn
  target_id        = aws_instance.web_instance.id
  port            = 80

  depends_on = [aws_instance.web_instance]
}