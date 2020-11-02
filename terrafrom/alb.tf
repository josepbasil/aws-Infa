resource "aws_security_group" "alb" {
  name        = "Demo_alb_security_group"
  description = "Demo load balancer security group"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ALB"
  }
}

resource "aws_alb" "demo" {
  name            = "my-demo-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.main-public-1.id , aws_subnet.main-public-2.id]
  load_balancer_type = "application"
} 


resource "aws_alb_listener" "demo" {
  load_balancer_arn = aws_alb.demo.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.demo-blue.arn
    type             = "forward"
  }
lifecycle {
    ignore_changes = [
      default_action,
    ]
  }

}

resource "aws_alb_target_group" "demo-blue" {
  name                 = "demo-http-blue"
  port                 = "8080"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
    path                 = "/version"
    interval            = 30
  }
}

resource "aws_alb_listener" "demo-green" {
  load_balancer_arn = aws_alb.demo.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.demo-green.arn
    type             = "forward"
  }
lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}


resource "aws_alb_target_group" "demo-green" {
  name                 = "demo-http-green"
  port                 = "80"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
    path                 = "/version"
    interval            = 30
  }
}

