resource "aws_elb" "main" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-east-2"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "test-lb-tf-1367388845.us-east-2.elb.amazonaws.com"
  name    = "sairam.cf"
  type    = "A"

  alias {
    name                   = "sairam.cf"
    zone_id                = "test-lb-tf-1367388845.us-east-2.elb.amazonaws.com"
    evaluate_target_health = true
  }
}
