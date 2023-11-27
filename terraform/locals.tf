locals {
    containers = {
        for i, tag_name in var.tag_names :
            tag_name => {
                ami_value       = var.ami_values[i]
                instance_type   = var.instance_types[i]
                instance_state  = var.instance_states[i]
                tag_name        = var.tag_names[i]
            }
    }
}

