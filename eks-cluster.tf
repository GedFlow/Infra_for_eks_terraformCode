resource "aws_eks_cluster" "my-eks" {
  name     = "my-eks"
  role_arn = var.role_eks_cluster
  version  = "1.32"

  vpc_config {
    subnet_ids              = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  # 이 코드는 Role에 정책이 먼저 연결된 후 본 클러스터가 생성되도록 돕는다. 현재는 Role을 테라폼으로 생성하지 않으므로 주석처리한다.
  # depends_on = [
  #   aws_iam_role_policy_attachment.AmazonEKSClusterPolicy_Attachment,
  # ]
}

output "endpoint" {
  value = aws_eks_cluster.my-eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-eks.certificate_authority.0.data
}
