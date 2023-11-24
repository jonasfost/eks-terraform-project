################################################################################
# Route53 ressource
################################################################################

# resource "aws_route53_record" "www_knote" {
#   zone_id = data.aws_route53_zone.johnyfoster_zone.zone_id
#   name    = "www.knote.${data.aws_route53_zone.johnyfoster_zone.name}"
#   type    = "A"
#   # ttl     = 300
#   # records = [module.alb.lb_arn]
#   alias {
#     name                   = module.alb.lb_dns_name
#     zone_id                = module.alb.lb_zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_route53_record" "knote" {
#   zone_id = data.aws_route53_zone.johnyfoster_zone.zone_id
#   name    = "knote.${data.aws_route53_zone.johnyfoster_zone.name}"
#   type    = "A"
#   # ttl     = 300
#   # records = [module.alb.lb_arn]
#   alias {
#     name                   = module.alb.lb_dns_name
#     zone_id                = module.alb.lb_zone_id
#     evaluate_target_health = true
#   }
# }
