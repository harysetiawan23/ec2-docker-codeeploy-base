output "instances_pubic_ip" {
  description = "Instances Public IP [Dynamic]"
  depends_on = [
    aws_instance.ec2_docker
  ]
  value = aws_instance.ec2_docker.public_ip
}


output "instances_pubic_dns" {
  description = "Instances Public DNS"
  depends_on = [
    aws_instance.ec2_docker
  ]
  value = aws_instance.ec2_docker.public_dns
}


output "instance_security_group" {
  depends_on = [
    aws_security_group.ec2_docker_sg
  ]
  description = "Security Group for instances"
  value = aws_security_group.ec2_docker_sg.id
}