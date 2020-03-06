data "aws_availability_zones" "all" {}
### Creating Security Group for EC2
#resource "aws_security_group" "instance" {
#  name = "terraform-example-instance"
#  ingress {
#    from_port = 8080
#    to_port = 8080
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
## Security Group for ELB
#resource "aws_security_group" "elb" {
#  name = "terraform-example-elb"
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    from_port = 80
#    to_port = 80
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
### Creating ELB
resource "aws_elb" "elb" {
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
