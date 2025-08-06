variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_base_name" {
  description = "A base name for all created resources."
  type        = string
  default     = "my-eks"
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instances."
  type        = string
}

variable "ami_id" {
  default = "ami-0fc8aeaa301af7663" # x86 아마존 리눅스
  # default = "ami-0d5b75db8f1e3ef15"  # ARM 아마존 리눅스
  type = string
}

variable "sg_ingress_ssh_cidr" {
  description = "The IP address range that can be used for SSH access."
  type        = string
  default     = "0.0.0.0/0"
}

variable "my_instance_type" {
  description = "EC2 instance type for the management host."
  type        = string
  default     = "t3.micro"
}

variable "availability_zone_1" {
  description = "First availability zone."
  type        = string
  default     = "ap-northeast-2a"
}

variable "availability_zone_2" {
  description = "Second availability zone."
  type        = string
  default     = "ap-northeast-2c"
}

variable "vpc_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_1_block" {
  description = "CIDR block for the first public subnet."
  type        = string
  default     = "192.168.1.0/24"
}

variable "public_subnet_2_block" {
  description = "CIDR block for the second public subnet."
  type        = string
  default     = "192.168.2.0/24"
}

variable "private_subnet_1_block" {
  description = "CIDR block for the first private subnet."
  type        = string
  default     = "192.168.3.0/24"
}

variable "private_subnet_2_block" {
  description = "CIDR block for the second private subnet."
  type        = string
  default     = "192.168.4.0/24"
}