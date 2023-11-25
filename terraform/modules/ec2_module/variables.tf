variable "ami_value" {
    type        = string
    description = "The ami value of the instance to create" 
}

variable "instance_type" {
    type        = string
    description = "The type of the instance to create"
}

variable "instance_state" {
    type        = string
    description = "The default state for the instance"
}

variable "tag_name" {
    type        = string
    description = "Instance tag name"
}

