
output "lbarnpublic"{
value= aws_alb.my_lb.arn
}
output "lbarnprivate"{
   value= aws_alb.my_lb_private.arn

}

