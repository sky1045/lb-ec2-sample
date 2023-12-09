variable "name" {
  description = "general name"
  default     = "test"
}

variable "instance_type" {
  description = "instance_type"
  default     = "t4g.nano"
}

variable "public_subnets" {
  description = "map {AZ = Cidr} for new public subnets"
  default = {
    "ap-northeast-2a" = "10.0.0.0/20"
  }
}

variable "private_subnets" {
  description = "map {AZ = Cidr} for new private subnets"
  default = {
    "ap-northeast-2a" = "10.0.128.0/20"
  }
}
