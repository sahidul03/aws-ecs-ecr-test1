variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region"
}
variable "env" {
  description = "Targeted Depolyment environment"
  default     = "dev"
}
variable "photo_desk_project_repository_name" {
  description = "PhotoDesk Project Repository name to connect to"
  default     = "sahidul03/PhotoDesk"
}
variable "photo_desk_project_repository_branch" {
  description = "PhotoDesk Project Repository branch to connect to"
  default     = "master"
}

variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = "photo-desk-cicd-artifacts-bucket"
}

variable "aws_ecs_cluster_name" {
  description = "Target Amazon ECS Cluster Name"
  default     = "ecs-ecr-test1-cluster"
}

variable "aws_ecs_node_app_service_name" {
  description = "Target Amazon ECS Cluster PhotoDesk App Service name"
  default     = "ecs-ecr-test1-service"
}

variable "dockerhub_credentials" {
  type        = string
}

variable "codestar_connector_credentials" {
  type        = string
}
