module "vpc" {
  source = "../modules/vpc"
}

module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id
  
  ec2_ingress_rules = [
    {
      from_port      = 22
      to_port        = 22
      protocol       = "tcp"
      cidr_blocks    = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
  
  alb_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
  rds_ingress_rules = [
    {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      cidr_blocks     = ["10.0.0.0/16"]
      security_groups = []
    }
  ]
}

module "alb" {
  source = "../modules/alb"

  # Core networking
  vpc_id = module.vpc.vpc_id

  # ALB placement (public subnet + SG)
  public_subnet_ids = [module.vpc.public_subnet_id]
  alb_sg_id         = [module.security.alb_sg_id]

  # Listener (HTTP for now)
  listener_port     = 80
  listener_protocol = "HTTP"

  # Target group
  target_group_name     = "${local.name_prefix}-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"

  # Health check
  health_check_path      = "/"
  health_check_protocol  = "HTTP"
  health_check_matcher   = "200"
  health_check_interval  = 30
  health_check_timeout   = 5
  healthy_threshold      = 2
  unhealthy_threshold    = 2

  # Attach EC2 to ALB
  ec2_instance_id = module.ec2.instance_id
}

module "ec2" {
  source = "../modules/ec2"

  subnet_id     = module.vpc.private_app_subnet_id
  sg_id         = module.security.ec2_sg_id
  key_pair_name = var.key_pair_name
}

module "rds" {
  source = "../modules/rds"

  db_subnet_group_name = module.vpc.private_db_subnet_id
  sg_id                = module.security.rds_sg_id
  db_username          = var.db_username
  db_password          = var.db_password
}

module "s3" {
  source = "../modules/s3"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

module "lambda" {
  source = "../modules/lambda"

  subnet_id = module.vpc.private_app_subnet_id
  sg_id     = module.security.ec2_sg_id
  role_arn  = aws_iam_role.lambda_role.arn
}