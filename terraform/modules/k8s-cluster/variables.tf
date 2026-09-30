# variables.tf

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "key_name" {
  type    = string
  default = "us-east-1-key"
}

variable "key_path" {
  type      = string
  default   = "C:\\Users\\91995\\Downloads\\k8s-us-east-key.pub"
  sensitive = true
}