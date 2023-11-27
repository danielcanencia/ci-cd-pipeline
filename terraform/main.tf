// Define variables, to be used by terraform.tfvars
variable "region_value" {
    type        = string
    description = <<EOF
        The region in which the instances
        are gonna be created
    EOF
}
variable "ami_values" {
    type        = list(string)
    description = "The ami value of the instance to create" 
}
variable "instance_types" {
    type        = list(string)
    description = "The type of the instance to create"
}
variable "instance_states" {
    type        = list(string)
    description = "The default states for the instances"
}
variable "tag_names" {
    type        = list(string)
    description = "Instance tag name"
}


// Define aliases for providers
provider "aws" {
    alias = "primary_provider"
    region = var.region_value
}



module "ec2_module" {
    source = "./modules/ec2_module"
    providers = {
        aws.primary = aws.primary_provider
    }

    // One map per instance to create
    for_each = local.containers

    // Values to pass to the aws_instance resource
    ami_value       = each.value.ami_value
    instance_type   = each.value.instance_type
    instance_state  = each.value.instance_state
    tag_name        = each.value.tag_name    
}

