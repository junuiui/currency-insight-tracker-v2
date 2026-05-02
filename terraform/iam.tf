# 1. ECS Task Execution Role (에이전트용)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "currency-v2-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# AWS가 미리 만들어둔 관리형 정책 연결 (ECR, Logging 권한 포함)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 2. ECS Task Role (앱 코드용 - DynamoDB 접근)
resource "aws_iam_role" "ecs_task_role" {
  name = "currency-v2-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}


# DynamoDB 접근 권한 정책 정의
data "aws_dynamodb_table" "existing_table" {
  name = "CurrencyRates"
}

resource "aws_iam_role_policy" "ecs_dynamodb_policy" {
  name = "ecs-dynamodb-policy"
  role = aws_iam_role.ecs_task_role.id # Task Execution Role이 아닌 Task Role!!

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        Effect = "Allow",
        # 위에서 가져온 기존 테이블의 ARN을 사용합니다.
        Resource = data.aws_dynamodb_table.existing_table.arn
      }
    ]
  })
}
