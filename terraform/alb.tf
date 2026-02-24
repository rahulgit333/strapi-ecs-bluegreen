resource "aws_lb" "alb" {

  name = "my-strapi-app-alb"

  load_balancer_type = "application"

  subnets = aws_subnet.public[*].id

  security_groups = [aws_security_group.alb_sg.id]

}

resource "aws_lb_target_group" "blue" {

  name = "my-strapi-blue"

  port = 1337

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  target_type = "ip"

}

resource "aws_lb_target_group" "green" {

  name = "my-strapi-green"

  port = 1337

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  target_type = "ip"

}

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.blue.arn

  }

}
