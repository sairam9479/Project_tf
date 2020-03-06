
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

resource "aws_acm_certificate" "my_cert" {
  domain_name       = "sairam.cf"
  validation_method = "NONE"

}

