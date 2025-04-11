resource "aws_instance" "create" {
    instance_type = "t2.micro"
    ami = "ami-00a929b66ed6e0de6"
    subnet_id = var.sub
    security_groups = [var.sg]
    key_name = var.key
    associate_public_ip_address = true
    tags =  {
        Name = var.name
    }

}

variable "name" {
    type = string
}
variable "sg" {
    type = string
}
variable "sub" {
    type = string
}
variable "key" {
    type = string
}