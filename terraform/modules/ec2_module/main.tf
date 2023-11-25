terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            configuration_aliases = [aws.primary]
        }
    }
}

resource "aws_instance" "instance" {
    provider = aws.primary
    ami = var.ami_value
    instance_type = var.instance_type

    tags = {
        Name = var.tag_name
    }
}

resource "aws_ec2_instance_state" "instance_state" {
  instance_id = aws_instance.instance.id
  state       = var.instance_state
}

