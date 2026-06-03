resource "aws_instance" "web_server" {
  ami           = ami-0685bcc683dadb6b9
  instance_type = "t2.nano"

  tags = {
    Name        = "Terraform-EC2-Example"
    Environment = "Dev"
  }
}