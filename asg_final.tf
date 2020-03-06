###asg



###asg
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "lc_confg"
  image_id      = "ami-099cfc8856fdce3b7"
  instance_type = "t2.micro"
  security_groups    = ["sg-093299b047c5d6dfd"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "launch_confg" {
  name                 = "terraform-asg"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  vpc_zone_identifier  = ["subnet-f8327d82", "subnet-a75948cf", "subnet-0166d14d"]
  min_size             = 2
  max_size             = 4

  lifecycle {
    create_before_destroy = true
  }
}

### Creating ELB
resource "aws_elb" "elb_terraform" {
  name = "elbex"
  subnets  = ["subnet-f8327d82", "subnet-a75948cf", "subnet-0166d14d"]
  security_groups = ["sg-093299b047c5d6dfd"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.launch_confg.id}"
  elb                    = "${aws_elb.elb_terraform.id}"
}


####r53

resource "aws_route53_zone" "website" {
  name   = "sairam.cf"
}
resource "aws_route53_record" "website" {
  zone_id = "${aws_route53_zone.website.zone_id}"
  name    = "sairam.cf"
  type    = "A"

  alias {
    name                   = "${aws_elb.elb_terraform.dns_name}"
    zone_id                = "${aws_elb.elb_terraform.zone_id}"
    evaluate_target_health = true
  }
}
