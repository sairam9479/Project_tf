###asg
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-019f8203e0053eeba"
  instance_type = "t2.micro"
  security_groups    = ["sg-093299b047c5d6dfd"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform-lc-example-" {
  name                 = "terraform-asg-example"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  vpc_zone_identifier  = ["subnet-f8327d82", "subnet-a75948cf", "subnet-0166d14d"]
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}


###alb

resource "aws_lb" "terraform-asg-example" {
  name               = "terraform-asg-example-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-093299b047c5d6dfd"]
  subnets            = ["subnet-f8327d82", "subnet-a75948cf", "subnet-0166d14d"]

  enable_deletion_protection = false
 }


####r53

resource "aws_route53_zone" "terraform-asg-example-lb-tf" {
  name   = "sairam.cf"
}
resource "aws_route53_record" "terraform-asg-example-lb-tf" {
  zone_id = "${aws_route53_zone.terraform-asg-example-lb-tf.zone_id}"
  name    = "sairam.cf"
  type    = "A"

  alias {
    name                   = "${aws_lb.terraform-asg-example.dns_name}"
    zone_id                = "${aws_lb.terraform-asg-example.zone_id}"
    evaluate_target_health = true
  }
}
