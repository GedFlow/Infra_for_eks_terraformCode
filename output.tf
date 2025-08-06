output "management_host_public_ip" {
  description = "Public IP address of the EKS management host (Bastion Host)."
  value       = aws_instance.eks_ec2_host.public_ip
}