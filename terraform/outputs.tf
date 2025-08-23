output "vpc_id" {
  value = module.vpc_coaching.vpc_id
}

output "alb_listener_arn" {
  value = aws_lb_listener.web_app.arn
}

output "alb_dns_name" {
  value = "http://${module.alb.lb_dns_name}"
}