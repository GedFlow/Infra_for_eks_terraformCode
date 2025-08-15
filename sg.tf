#######################
# logging 서버 보안그룹
#######################
resource "aws_security_group" "logging_sg" {
  name        = "Logging-SG"
  description = "logging server Security Group"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "Allow All from specified CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.sg_ingress_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
