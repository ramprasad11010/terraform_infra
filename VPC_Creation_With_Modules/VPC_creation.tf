module "VPC_Creation" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.19.0"
    name = "root_module_VPC"
    cidr = "10.20.0.0/16"
}

output "VPC_Details" {
    value = module.VPC_Creation.vpc_id
}