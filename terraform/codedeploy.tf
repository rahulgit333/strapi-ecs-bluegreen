resource "aws_codedeploy_app" "app" {

  name = "my-strapi-app"

  compute_platform = "ECS"

}

resource "aws_codedeploy_deployment_group" "group" {

  app_name = aws_codedeploy_app.app.name

  deployment_group_name = "my-strapi-app-dg"

  service_role_arn = aws_iam_role.codedeploy.arn

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {

    deployment_option = "WITH_TRAFFIC_CONTROL"

    deployment_type = "BLUE_GREEN"

  }

  ecs_service {

    cluster_name = aws_ecs_cluster.cluster.name

    service_name = aws_ecs_service.service.name

  }

  load_balancer_info {

    target_group_pair_info {

      prod_traffic_route {

        listener_arns = [aws_lb_listener.listener.arn]

      }

      target_group {

        name = aws_lb_target_group.blue.name

      }

      target_group {

        name = aws_lb_target_group.green.name

      }

    }

  }

}
