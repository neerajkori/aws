variable "vpc_name" {
  type        = string
  description = "Name of the VPC to Create"
  default     = "Demo-VPC"
}

variable "deployment_region" {
  type        = string
  description = "Aws Region for resource deployment."
  default     = "ap-south-1"
}

variable "cidr_block" {
  type        = string
  description = "cidr range for VPC to create"
  default     = "192.168.0.0/16"
}

variable "vpc_subnet" {
  type        = map(string)
  description = "List of subnets to be created within VPC"
  default = {
    "192.168.1.0/24" = "Demo-PublicSubnet-1a",
    "192.168.2.0/24" = "Demo-PublicSubnet-1b",
    "192.168.3.0/24" = "Demo-PrivateSubnet-1a",
    "192.168.4.0/24" = "Demo-PrivateSubnet-1b"
  }
}

variable "vpc_route_tables" {
  type        = list(string)
  description = "List of route tables need to be created within vpc"
  default     = ["Demo-PublicRT", "Demo-PrivateRT"]
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups need to be created."
  default     = ["Demo-PublicSG", "Demo-PrivateSG"]
}

variable "internet_gateway" {
  type        = string
  description = "Internet Gateway for the to talk to internet."
  default     = "Demo-IGW"
}

variable "BastionHost_config" {
  type        = map(string)
  description = "This will defind the Bation Host properties to use for instance/ machine creation."
  default = {
    "instance_typ" = "t3.micro"
    "tenancy"      = "default"
    "keyname"      = "testing"
  }

}
