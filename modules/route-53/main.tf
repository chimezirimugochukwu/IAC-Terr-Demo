# create an A record to point domain name to load balancer
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  
  

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}