variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "ami" {}

variable "instance_type" {
  default = "t3a.medium"
}

variable "subnet_id" {}
variable "delete_on_termination" {
  type = bool
  default = true
}
variable "volume_type" {
  default = "gp3"
}
variable "volume_size" {
  type = string
  default = "30"
}
variable "role" {}
variable "security_groups" {
  type = list(string)
}
variable "monitoring" {
  type = bool
  default = false
}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "user_data" {}