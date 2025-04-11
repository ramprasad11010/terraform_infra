resource "aws_vpc" "root_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Root VPC"
  }
}

resource "aws_security_group" "alpha" {
    name = "alpha - open"
    description = "Allows all traffic "
    vpc_id = aws_vpc.root_vpc.id
    
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
    security_group_id = aws_security_group.alpha.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = -1
    ip_protocol       = -1
    to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ICMP" {
    security_group_id = aws_security_group.alpha.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = -1
    ip_protocol       = "icmp"
    to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_tls_ipv4_out" {
    security_group_id = aws_security_group.alpha.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = -1
    ip_protocol       = -1
    to_port           = -1
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_subnet" "private_sub_1" {
    vpc_id = aws_vpc.root_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a" # Replace with your desired AZ
    tags = {
        Name = "Private Subnet 1"
    }
}

resource "aws_internet_gateway" "myIGW" {
    vpc_id = aws_vpc.root_vpc.id
    tags = {
        Name = "My Internet gateway"
    }
}

resource "aws_default_route_table" "root_route_table" {
    default_route_table_id = aws_vpc.root_vpc.default_route_table_id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIGW.id
    }
    tags = {
        Name = "My Default Route"
    }
}

resource "aws_instance" "jump" {
    instance_type = "t2.micro"
    ami = "ami-00a929b66ed6e0de6"
    subnet_id = aws_subnet.private_sub_1.id
    security_groups = [aws_security_group.alpha.id]
    key_name = aws_key_pair.kp.key_name
    associate_public_ip_address = true
    tags =  {
        Name = "jump_server"
    }

}

