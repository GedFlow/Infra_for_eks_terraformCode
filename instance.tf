#-----------------------------
# Logging 서버 (Elasticsearch, Kibana)
#-----------------------------
resource "aws_instance" "logging-server" {
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.eks_ec2_sg.id]
  associate_public_ip_address = true
  private_ip                  = "192.168.2.100"

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/init.sh", {
    aws_region        = var.aws_region,
    cluster_base_name = var.cluster_base_name
  })
}
