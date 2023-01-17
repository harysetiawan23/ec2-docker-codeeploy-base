data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  id = var.subnet_id
}

data "aws_key_pair" "staging_central_v2"{
  key_name = var.key_name
}