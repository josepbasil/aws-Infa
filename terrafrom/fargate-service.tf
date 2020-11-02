resource "aws_ecs_task_definition" "demo" {
  family             = "demo"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn      = aws_iam_role.ecs-demo-task-role.arn
  cpu                = 256
  memory             = 512
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<DEFINITION
[
  {
    "essential": true,
    "image": "${aws_ecr_repository.demo.repository_url}",
    "name": "demo",
    "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
               "awslogs-group" : "demo",
               "awslogs-region": "${var.AWS_REGION}",
               "awslogs-stream-prefix": "ecs"
            }
     },
     "secrets": [],
     "environment": [],
     "healthCheck": {
       "command": [ "CMD-SHELL", "curl -f http://localhost:8080/version || exit 0" ],
       "interval": 30,
       "retries": 3,
       "timeout": 5
     }, 
     "portMappings": [
        {
           "containerPort": 8080,
           "hostPort": 8080,
           "protocol": "tcp"
        }
     ]
  }
]
DEFINITION

}

resource "aws_ecs_service" "demo" {
  name            = "demo"
  cluster         = aws_ecs_cluster.demo.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.demo.arn
  launch_type     = "FARGATE"
  depends_on      = [aws_alb_listener.demo]

  deployment_controller {
    type = "CODE_DEPLOY"
  }
 network_configuration {
    subnets         = [aws_subnet.main-public-1.id , aws_subnet.main-public-2.id]
    security_groups  = [aws_security_group.ecs-demo.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.demo-blue.arn
    container_name   = "demo"
    container_port   = "8080"
  }
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }


}
# security group
resource "aws_security_group" "ecs-demo" {
  name        = "ECS demo"
  vpc_id      = aws_vpc.main.id
  description = "ECS demo"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

# logs
resource "aws_cloudwatch_log_group" "demo" {
  name = "demo"
}

