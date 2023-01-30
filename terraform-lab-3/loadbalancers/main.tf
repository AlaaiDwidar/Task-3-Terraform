

#Create Application Load Balancer
resource "aws_alb" "my_lb" {
  name               = "mylb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [
    var.webid1,
    var.webid2,
  ]
}

resource "aws_alb" "my_lb_private" {
  name               = "mylbprivate"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [
    var.webid3,
    var.webid4,
  ]
}

#Create LB Listner
resource "aws_alb_listener" "lb_listener" {
  load_balancer_arn = var.lbarnpublic
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "lb_listener_private" {
  load_balancer_arn = var.lbarnprivate
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.lb_target_group_private.arn
    type             = "forward"
  }
}

#Create LB TG
resource "aws_alb_target_group" "lb_target_group" {
  name     = "mytg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_alb_target_group" "lb_target_group_private" {
  name     = "mytgprivate"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

#Create LoadBalancer Target Group Attachment to my Instances
resource "aws_alb_target_group_attachment" "attach_target_group" {
  target_group_arn = aws_alb_target_group.lb_target_group.arn
  port = 80
  target_id = var.vmid1

}

resource "aws_alb_target_group_attachment" "attach_target_group2" {
  target_group_arn = aws_alb_target_group.lb_target_group.arn
  port = 80
  target_id =var.vmid2
 
}

resource "aws_alb_target_group_attachment" "attach_target_group3" {
  target_group_arn = aws_alb_target_group.lb_target_group_private.arn
  port = 80
  target_id = var.vmid3

}


resource "aws_alb_target_group_attachment" "attach_target_group4" {
  target_group_arn = aws_alb_target_group.lb_target_group_private.arn
  port = 80
  target_id = var.vmid4

}

#Create Load Balancer Secuirty Group
resource "aws_security_group" "lb_sg" {
  description = "Load Balancer Secuirty Group"
  vpc_id      = var.vpc
ingress {
    description = var.protocol
    from_port   = var.port80
    to_port     = var.port80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }
  tags = {
    Name = "LoadBalancerSecuirtyGroup"
  }
}

