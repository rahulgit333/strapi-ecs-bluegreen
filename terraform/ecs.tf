resource "aws_ecs_cluster" "cluster" {

  name = "my-strapi-app-cluster"

}

resource "aws_ecs_task_definition" "task" {

  family = "my-strapi-app"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = "512"

  memory = "1024"

  execution_role_arn = aws_iam_role.ecs_execution.arn

  container_definitions = file("../taskdef.json")

}

resource "aws_ecs_service" "service" {

  name = "my-strapi-app-service"

  cluster = aws_ecs_cluster.cluster.id

  task_definition = aws_ecs_task_definition.task.arn

  desired_count = 1

  launch_type = "FARGATE"

  deployment_controller {

    type = "CODE_DEPLOY"

  }

  network_configuration {

    subnets = aws_subnet.public[*].id

    security_groups = [aws_security_group.ecs_sg.id]

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.blue.arn

    container_name = "my-strapi-app"

    container_port = 1337

  }

}
