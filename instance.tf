#-----------------------------
# EKS 관리용 EC2 (Bastion Host)
#-----------------------------

resource "aws_security_group" "eks_ec2_sg" {
  name        = "${var.cluster_base_name}-HOST-SG"
  description = "eksctl-host Security Group"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "Allow All from specified CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # '-1' means all protocols
    cidr_blocks = [var.sg_ingress_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_base_name}-HOST-SG"
  }
}

resource "aws_instance" "eks_ec2_host" {
  ami                         = var.ami_id
  instance_type               = var.my_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.eks_ec2_sg.id]
  associate_public_ip_address = true
  private_ip                  = "192.168.1.100"

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/init.sh", {
    aws_region        = var.aws_region,
    cluster_base_name = var.cluster_base_name
  })


  tags = {
    Name = "${var.cluster_base_name}-host"
  }
}