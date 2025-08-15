resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.my-eks.name
  node_group_name = "worker"
  node_role_arn   = var.role_eks_nodegroup
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  instance_types = ["g4dn.xlarge"]        # 인스턴스 타입 설정
  ami_type       = "AL2023_x86_64_NVIDIA" # AMI 설정

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [aws_security_group.eks_ec2_sg.id]
  }

  # 이 코드는 Role에 정책이 먼저 연결된 후 본 노드그룹이 생성되도록 돕는다. 현재는 Role을 테라폼으로 생성하지 않으므로 주석처리한다.
  # depends_on = [
  #   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly_Attachment,
  #   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy_Attachment,
  #   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy_Attachment,
  # ]
}
