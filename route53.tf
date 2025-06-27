
# Route 53 Zone
resource "aws_route53_zone" "primary" {
  name = "yourdomain.com" # Replace with your domain
}

# Route 53 Record for CloudFront
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.yourdomain.com" # Replace with your subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route 53 Record for ALB (API)
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.yourdomain.com" # Replace with your API subdomain
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}