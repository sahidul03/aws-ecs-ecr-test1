#!/bin/sh

REGION="ap-northeast-1"
AWS_ACCOUNT_ID="xxxxxxx"
PROFILE="sahidboss"
SERVICE_NAME="ecs-ecr-test1-repo"
SERVICE_TAG="latest"
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"


if [ "$1" = "ecr_plan" ];then
    cd 1_ECR
    terraform init -backend-config="backend-config.config"
    terraform plan
elif [ "$1" = "ecr_apply" ];then
    cd 1_ECR
    terraform init -backend-config="backend-config.config"
    terraform apply -auto-approve
elif [ "$1" = "build" ];then
    cd your_backend_project_directory
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
    docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "dockerize" ];then
    aws ecr get-login-password \
    --region ${REGION} \
    --profile ${PROFILE} \
    | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

    docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "ecs_an_others_plan" ];then
    cd 2_ECS_AND_OTHERS
    terraform init -backend-config="backend-config.config"
    terraform plan
elif [ "$1" = "ecs_an_others_apply" ];then
    cd 2_ECS_AND_OTHERS
    terraform init -backend-config="backend-config.config"
    terraform apply -auto-approve
elif [ "$1" = "deployment_plan" ];then
    cd 3_DEPLOYMENT
    terraform init -backend-config="backend-config.config"
    terraform plan
elif [ "$1" = "deployment_apply" ];then
    cd 3_DEPLOYMENT
    terraform init -backend-config="backend-config.config"
    terraform apply -auto-approve
elif [ "$1" = "destroy_all" ];then
    cd 3_DEPLOYMENT
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve

    cd ../2_ECS_AND_OTHERS
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve

    cd ../1_ECR
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve
elif [ "$1" = "destroy_deployment" ];then
    cd 3_DEPLOYMENT
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve
elif [ "$1" = "destroy_ecs_and_others" ];then
    cd 2_ECS_AND_OTHERS
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve
elif [ "$1" = "destroy_ecr" ];then
    cd 1_ECR
    terraform init -backend-config="backend-config.config"
    terraform destroy -auto-approve
fi
