# output "address" {
#   value = aws_elb.web.dns_name
# }

output "code_build_project" {
  value = aws_codebuild_project.containerAppBuild.arn
}
output "photo_desk_app_codepipeline_project" {
  value = aws_codepipeline.photo_desk_app_pipeline.arn
}