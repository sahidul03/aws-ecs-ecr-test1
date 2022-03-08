data "aws_route53_zone" "ecr_ecs_test1" {
  name = var.domain_name
}

resource "aws_route53_record" "ecr_ecs_test1_demo" {
  zone_id = data.aws_route53_zone.ecr_ecs_test1.zone_id
  name    = join(".", ["photo-desk", data.aws_route53_zone.ecr_ecs_test1.name])
  type    = "A"
  alias {
    name                   = aws_lb.ecs_ecr_test1_lb.dns_name
    zone_id                = aws_lb.ecs_ecr_test1_lb.zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_lb.ecs_ecr_test1_lb
  ]
}

resource "aws_acm_certificate" "ecr_ecs_test1_demo_acm_ctc" {
  domain_name               = aws_route53_record.ecr_ecs_test1_demo.name
  subject_alternative_names = ["*.${aws_route53_record.ecr_ecs_test1_demo.name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_route53_record.ecr_ecs_test1_demo
  ]
}

resource "aws_route53_record" "ecr_ecs_test1_demo_ctc_record" {
  for_each = {
  for option in aws_acm_certificate.ecr_ecs_test1_demo_acm_ctc.domain_validation_options : option.domain_name => {
    name   = option.resource_record_name
    record = option.resource_record_value
    type   = option.resource_record_type
  }
  }
  zone_id         = data.aws_route53_zone.ecr_ecs_test1.zone_id
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
}

resource "aws_acm_certificate_validation" "ecr_ecs_test1_demo_validation_ctc" {
  certificate_arn         = aws_acm_certificate.ecr_ecs_test1_demo_acm_ctc.arn
  validation_record_fqdns = [for record in aws_route53_record.ecr_ecs_test1_demo_ctc_record : record.fqdn]
}
