resource "aws_ecs_service" "ecs_ecr_test1_service" {
  name            = "ecs-ecr-test1-service"                        # Naming our first service
  cluster         = aws_ecs_cluster.ecs_ecr_test1_cluster.id       # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.ecs_ecr_test1_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 2 # Setting the number of containers we want deployed to 2

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_ecr_test1_tg.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.ecs_ecr_test1_task.family
    container_port   = 3050 # Specifying the container port
  }

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    assign_public_ip = true # Providing our containers with public IPs [improve]
    security_groups  = [aws_security_group.ecs_ecr_test1_service_sg.id]
  }
}

resource "aws_security_group" "ecs_ecr_test1_service_sg" {
  vpc_id      = aws_vpc.ecs_ecr_test1_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.ecs_ecr_test1_lb_sg.id]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}