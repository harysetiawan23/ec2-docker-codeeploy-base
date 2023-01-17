terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }

  backend "s3" {
  }
}



resource "aws_instance" "ec2_docker" {
  ami           = "ami-051b6c782f8322450"
  instance_type = "t2.micro"

  user_data = file("./install-docker.sh")
  subnet_id = data.aws_subnet.public.id

  security_groups = ["${aws_security_group.ec2_docker_sg.id}"]

  key_name = data.aws_key_pair.staging_central_v2.key_name
  tags = {
    "Name" = var.app_name
  }


  iam_instance_profile = aws_iam_role.app_iam_role.name


  depends_on = [
    aws_iam_role.app_iam_role,
    aws_security_group.ec2_docker_sg
  ]
}

resource "aws_iam_role" "app_iam_role" {
  name = "${var.app_name}-codedeploy-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "codedeploy.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF
}

resource "aws_iam_instance_profile" "AWSInstanceProfile" {
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.app_iam_role.name
}

resource "aws_security_group" "ec2_docker_sg" {
  name   = "${var.app_name}-security"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.238.23.247/32"]
    description = "Centralise VPN"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internet"
  }
}

resource "aws_codedeploy_app" "app_docker" {
  name = var.app_name
}

resource "aws_sns_topic" "app_docker_sns_topic" {
  name = "${var.app_name}_codedeploy_notification"
}


resource "aws_codedeploy_deployment_group" "app_docker_codedeploy_group" {
  app_name              = aws_codedeploy_app.app_docker.name
  deployment_group_name = var.environment
  service_role_arn      = aws_iam_role.app_iam_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = var.app_name
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "failure_trigger"
    trigger_target_arn = aws_sns_topic.app_docker_sns_topic.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["${var.app_name}-deoloyment-alarm"]
    enabled = true
  }
}



