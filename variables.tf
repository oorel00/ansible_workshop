variable "amis" {
  type = map(string)
  default = {
    "us-east-2" = "ami-03291866"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "region" {
  default = "us-east-2"
}

variable "zones" {
  default = ["a", "b", "c"]
}

variable "username" {
  default = "ec2-user"
}

variable "key_name" {
  default = "workshop"
}
