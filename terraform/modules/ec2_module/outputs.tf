output "public_ip_address" {
    description = "Newly created instance public ip address"
    value = "${aws_instance.instance.tags["Name"]} : ${aws_instance.instance.public_ip}"
}

