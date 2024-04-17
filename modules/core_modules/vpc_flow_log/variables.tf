variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "log_destination" {}
variable "log_destination_type" {}

# accepted values {ACCEPT,REJECT,ALL}
variable "traffic_type" {
  type = string
}

variable "vpc_id" {}