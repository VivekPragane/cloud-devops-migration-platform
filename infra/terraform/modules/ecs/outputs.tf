output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ecs.name
}
