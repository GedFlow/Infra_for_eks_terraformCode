# ############################
# # OIDC Provider (IRSA 전제)
# ############################

# # EKS 클러스터 정보를 참조 (클러스터가 먼저 생성되어야 함)
# data "aws_eks_cluster" "this" {
#   name = aws_eks_cluster.my-eks.name
# }

# # Issuer의 루트 인증서 지문을 추출 (tls provider 필요)
# data "tls_certificate" "oidc" {
#   url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
# }

# # 사용자가 변수로 OIDC ARN을 넘겼는지 여부 (변수)
# locals {
#   use_existing_oidc = var.oidc_provider_arn != ""
# }

# # 조건 성공 시 - 기존 OIDC Provider ARN을 참조 (변수사용)
# data "aws_iam_openid_connect_provider" "existing" {
#   count = local.use_existing_oidc ? 1 : 0
#   arn   = var.oidc_provider_arn
# }

# # 조건 실패 시 - EKS Issuer로 새 OIDC Provider 생성 (변수사용)
# resource "aws_iam_openid_connect_provider" "eks" {
#   count           = local.use_existing_oidc ? 0 : 1
#   url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
# }

# # 공통적으로 참조할 ARN/URL/Host (변수사용)
# locals {
#   oidc_provider_arn = local.use_existing_oidc ? data.aws_iam_openid_connect_provider.existing[0].arn : aws_iam_openid_connect_provider.eks[0].arn
#   oidc_url          = local.use_existing_oidc ? data.aws_iam_openid_connect_provider.existing[0].url : aws_iam_openid_connect_provider.eks[0].url
#   oidc_host         = replace(local.oidc_url, "https://", "")
# }
