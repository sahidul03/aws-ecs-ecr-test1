resource "aws_lb" "ecs_ecr_test1_lb" {
  name               = "ecs-ecr-test1-lb" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  # Referencing the security group
  security_groups = [aws_security_group.ecs_ecr_test1_lb_sg.id]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "ecs_ecr_test1_lb_sg" {
  vpc_id      = aws_vpc.ecs_ecr_test1_vpc.id
  
  ingress {
    from_port   = 80 # Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  ingress {
    from_port   = 443 # Allowing traffic in from port 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

resource "aws_lb_target_group" "ecs_ecr_test1_tg" {
  name        = "ecs-ecr-test1-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs_ecr_test1_vpc.id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
  depends_on = [aws_lb.ecs_ecr_test1_lb]
}

resource "aws_lb_listener" "ecs_ecr_test1_listener_https" {
  load_balancer_arn = aws_lb.ecs_ecr_test1_lb.arn # Referencing our load balancer
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.ecr_ecs_test1_demo_acm_ctc.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_ecr_test1_tg.arn # Referencing our tagrte group
  }
}

resource "aws_lb_listener" "ecs_ecr_test1_listener_http" {
  load_balancer_arn = aws_lb.ecs_ecr_test1_lb.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
#resource "aws_lb_target_group_attachment" "ecs_ecr_test1_tg_attachment" {
#  target_group_arn = aws_lb_target_group.ecs_ecr_test1_tg.arn
#  target_id        = aws_ecs_service.ecs_ecr_test1_service.id
#}