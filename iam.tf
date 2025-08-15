# resource "aws_iam_role" "eksClusterRole" {
#   name               = "eksClusterRole"
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "eks.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy_Attachment" {
#   role       = aws_iam_role.eksClusterRole.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role" "eksNodeRole" {
#   name               = "eksNodeRole"
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "ec2.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_Attachment" {
#   role       = aws_iam_role.eksNodeRole.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_Attachment" {
#   role       = aws_iam_role.eksNodeRole.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_Attachment" {
#   role       = aws_iam_role.eksNodeRole.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

############################
# IRSA Role for Fluent Bit
############################

# locals {
#   sa_namespace = "logging"
#   sa_name      = "fluent-bit"
# }

# resource "aws_iam_role" "fluentbit" {
#   name = "eks-irsa-fluent-bit"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = local.oidc_provider_arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${local.oidc_host}:aud" = "sts.amazonaws.com",
#           "${local.oidc_host}:sub" = "system:serviceaccount:${local.sa_namespace}:${local.sa_name}"
#         }
#       }
#     }]
#   })
# }

# # (예시) Amazon OpenSearch *도메인형*에 쓰기 권한이 필요할 때
# # Serverless(AOSS)면 정책/ARN이 다릅니다. 도메인형만 해당.
# data "aws_caller_identity" "me" {}
# data "aws_region" "current" {}

# variable "opensearch_domain_name" {
#   description = "Amazon OpenSearch Service 도메인 이름(도메인형 사용 시)"
#   type        = string
#   default     = "" # 도메인형을 안 쓰면 비워두세요.
# }

# resource "aws_iam_policy" "fluentbit_os_write" {
#   count = var.opensearch_domain_name == "" ? 0 : 1
#   name  = "fluentbit-opensearch-write"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = ["es:ESHttpGet", "es:ESHttpPost", "es:ESHttpPut", "es:ESHttpDelete", "es:ESHttpHead"],
#       Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:domain/${var.opensearch_domain_name}/*"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "fluentbit_attach" {
#   count      = var.opensearch_domain_name == "" ? 0 : 1
#   role       = aws_iam_role.fluentbit.name
#   policy_arn = aws_iam_policy.fluentbit_os_write[0].arn
# }

# output "fluentbit_irsa_role_arn" {
#   value = aws_iam_role.fluentbit.arn
# }
