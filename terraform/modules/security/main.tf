resource "aws_security_group" "alb" {
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.alb_ingress_rules
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
}

resource "aws_security_group" "ec2" {
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.ec2_ingress_rules
        content {
            from_port       = ingress.value.from_port
            to_port         = ingress.value.to_port
            protocol        = ingress.value.protocol
            security_groups = ingress.value.security_groups
        }
    }
}

resource "aws_security_group" "rds" {
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.rds_ingress_rules
        content {
            from_port       = ingress.value.from_port
            to_port         = ingress.value.to_port
            protocol        = ingress.value.protocol
            security_groups = ingress.value.security_groups
        }
    }
}