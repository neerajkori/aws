data "aws_ami" "name" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = ["ami-0ff5003538b60d5ec"]
  }
}

# data "aws_ami" "BastionHostami" {
#   most_recent =  true
#   filter{

#   }
# }

data "aws_security_groups" "available" {
  depends_on = [aws_security_group.security-groups]
  filter {
    name   = "tag:Name"
    values = ["Demo-*"]
  }

}

data "aws_subnets" "BastionHost_subnet" {
  depends_on = [aws_subnet.vpc_subnet]
  filter {
    name   = "tag:Name"
    values = ["Demo-PublicSubnet-1a"]
  }
}

data "aws_availability_zones" "available_zones" {
  state  = "available"
  region = var.deployment_region
  filter {
    name   = "zone-name"
    values = ["ap-south-1a", "ap-south-1b"]
  }
}

data "aws_route_tables" "available_route-tables" {
  vpc_id = aws_vpc.demovpc.id
  filter {
    name   = "tag:Name"
    values = var.vpc_route_tables
  }
}

output "output_check" {
  value = data.aws_route_tables.available_route-tables
}