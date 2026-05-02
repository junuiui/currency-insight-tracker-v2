# 1. ECS 클러스터 (컨테이너들이 살 그룹)
resource "aws_ecs_cluster" "main" {
  name = "currency-v2-cluster"
}

# 2. ECS 보안 그룹 (ALB에서 오는 8000포트만 허용)
resource "aws_security_group" "ecs_sg" {
  name   = "currency-v2-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # 핵심: ALB 통해서만 접속 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. ECS Task Definition (컨테이너 상세 명세)
resource "aws_ecs_task_definition" "app" {
  family                   = "currency-v2-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn # ECR에서 이미지 가져올 권한
  task_role_arn            = aws_iam_role.ecs_task_role.arn           # DynamoDB 쓸 권한

  container_definitions = jsonencode([{
    name  = "currency-backend"
    image = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
    }]
    environment = [
      { name = "AWS_REGION", value = "us-west-2" },
      { name = "DYNAMODB_TABLE", value = "CurrencyRates" }
    ]
  }])
}

# 4. ECS Service
resource "aws_ecs_service" "main" {
  name            = "currency-v2-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_1.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "currency-backend"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}
