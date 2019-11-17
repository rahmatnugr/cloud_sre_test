terraform {
  required_version = ">= 0.12, < 0.13"
}

# ----
# ECS Fargate AWS Execution Role
# ---- 
data "aws_iam_policy_document" "ecs_task_exec_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "${var.name_prefix}_ecs_task_exec_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----
# ECS Fargate related resources
# ---- 
resource "aws_ecs_cluster" "fargate" {
  name = "${var.name_prefix}_fargate_cluster"

  tags = merge(
    {
      Name = "${var.name_prefix}_fargate_cluster"
    },
    var.tags
  )
}

resource "aws_ecs_task_definition" "fargate" {
  family = "${var.name_prefix}_fargate_task"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definitions
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn

  tags = merge(
    {
      Name = "${var.name_prefix}_fargate_task"
    },
    var.tags
  )
}

resource "aws_ecs_service" "fargate" {
  name = "${var.name_prefix}_fargate_service"

  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.fargate.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name == "" ? "${var.name_prefix}_container" : var.container_name
    container_port   = var.app_port
  }

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnets
    assign_public_ip = false
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_exec_role]

  tags = merge(
    {
      Name = "${var.name_prefix}_fargate_service"
    },
    var.tags
  )
}
