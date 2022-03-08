variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "ecr_repository_url" {
  type        = string
  default     = "xxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/ecs-ecr-test1-repo:latest"
  description = "URL of the docker image"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC cidr block"
}

variable "public_subnet_1_cidr" {
  default     = "10.0.1.0/24"
  description = "Public subnet 1 CIDR"
}

variable "public_subnet_2_cidr" {
  default     = "10.0.2.0/24"
  description = "Public subnet 2 CIDR"
}

variable "private_subnet_1_cidr" {
  default     = "10.0.4.0/24"
  description = "Private subnet 1 CIDR"
}

variable "private_subnet_2_cidr" {
  default     = "10.0.5.0/24"
  description = "Private subnet 2 CIDR"
}

variable "domain_name" {
  default = "sahid.xyz"
}