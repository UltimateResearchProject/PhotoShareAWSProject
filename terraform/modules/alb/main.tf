resource "aws_lb" "alb" {
  name               = "${var.target_group_name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = var.alb_sg_id
}

resource "aws_lb_target_group" "tg" {
    name     = var.target_group_name
    port     = var.target_group_port
    protocol = var.target_group_protocol
    vpc_id   = var.vpc_id

    health_check {
        path                = var.health_check_path
        protocol            = var.health_check_protocol
        matcher             = var.health_check_matcher
        interval            = var.health_check_interval
        timeout             = var.health_check_timeout
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb.arn
    port              = var.listener_port
    protocol          = var.listener_protocol

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_instance_id
  port             = 80
}

output "alb_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}