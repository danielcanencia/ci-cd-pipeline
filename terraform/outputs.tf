output "public_ip_addresses" {
    description = "Newly created instances public ip addresses"
    value = values(module.ec2_module)[*].public_ip_address
}

