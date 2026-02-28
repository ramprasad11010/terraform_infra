variable "public_ip" {
  type = bool
  description = "Enable public IP"
}
variable "subnet_id" {
    type = string
    description = "Subnet ID"
}
variable "security_group" {
    type = set(string)
    description = "Security Group ID"
}
variable "tags" {
  type = map(string)
  description = "Tags"
}
variable "file" {
  type = string
  description = "File name"
}
