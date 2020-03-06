provider "aws" {
  region     = "us-east-2"
}

resource "aws_instance" "java-jenkins-github-nginx" {
  ami           = "ami-019f8203e0053eeba"
  instance_type = "t2.micro"

}
