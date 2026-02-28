resource "aws_instance" "server" {
    ami = "ami-0c1fe732b5494dc14"
    instance_type = "t3.small"
    key_name = "AWS_KP"
    subnet_id = var.subnet_id
    associate_public_ip_address = var.public_ip
    vpc_security_group_ids = var.security_group
    tags = var.tags
    user_data = "${file(var.file)}"
}

