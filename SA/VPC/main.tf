resource "aws_vpc" "demovpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "vpc_subnet" {
  depends_on              = [aws_vpc.demovpc]
  vpc_id                  = aws_vpc.demovpc.id
  for_each                = tomap(var.vpc_subnet)
  map_public_ip_on_launch = strcontains(each.value, "PublicSubnet") ? true : false
  cidr_block              = each.key
  availability_zone       = strcontains(each.value, "1a") ? data.aws_availability_zones.available_zones.names[0] : data.aws_availability_zones.available_zones.names[1]
  tags = {
    Name = each.value
  }
}

resource "aws_route_table" "demo-RT" {
  depends_on = [aws_vpc.demovpc]
  for_each   = toset(var.vpc_route_tables)
  vpc_id     = aws_vpc.demovpc.id
  tags = {
    Name = each.value
  }
}

resource "aws_route_table_association" "route_association" {
  for_each = {
    for cidr, name in var.vpc_subnet :
    cidr => strcontains(name, "Public") ? "Demo-PublicRT" : "Demo-PrivateRT"
  }
  subnet_id      = aws_subnet.vpc_subnet[each.key].id
  route_table_id = aws_route_table.demo-RT[each.value].id
}

resource "aws_route" "PublicRT-internetAccess" {
  depends_on             = [aws_route_table.demo-RT,data.aws_route_tables.available_route-tables]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo-IGW.id
  route_table_id         = data.aws_route_tables.available_route-tables.ids[0]
}

resource "aws_internet_gateway" "demo-IGW" {
  depends_on = [aws_vpc.demovpc]
  vpc_id     = aws_vpc.demovpc.id
  tags = {
    Name = var.internet_gateway
  }
}
resource "aws_internet_gateway_attachment" "attachtoVPC" {
  depends_on          = [aws_vpc.demovpc, aws_internet_gateway.demo-IGW]
  internet_gateway_id = aws_internet_gateway.demo-IGW.id
  vpc_id              = aws_vpc.demovpc.id
}

# resource "aws_route_table_association" "attachtoDemo-VPC" {

#   gateway_id = aws_internet_gateway.demo-IGW.id
#   route_table_id =  data.aws_route_tables.available_route-tables.ids
# }

resource "aws_security_group" "security-groups" {
  for_each = toset(var.security_groups)
  vpc_id   = aws_vpc.demovpc.id
  name     = each.value
  tags = {
    Name = each.value
  }
}

resource "aws_vpc_security_group_ingress_rule" "PublicSG" {
  depends_on        = [aws_security_group.security-groups]
  for_each          = data.aws_security_group.details
  security_group_id = strcontains(each.value.name, "Demo-PublicSG")? each.value.id : ""
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH from anywhere."
}
# resource "aws_vpc_security_group_egress_rule" "PublicSG" {
#   depends_on        = [aws_security_group.security-groups]
#   for_each          = toset(data.aws_security_groups.available.ids)
#   security_group_id = each.value
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 0
#   to_port           = 65535
#   ip_protocol       = "tcp"
#   description       = "Allow all outboud traffic"
# }
resource "aws_instance" "BastionHost" {

  ami           = data.aws_ami.name.id
  instance_type = var.BastionHost_config.instance_typ
  key_name      = var.BastionHost_config.keyname
  tenancy       = var.BastionHost_config.tenancy
  subnet_id     = data.aws_subnets.BastionHost_subnet.ids[0]
  # vpc_security_group_ids      = strcontains(data.aws_security_groups.available.names[0],"Demo-PublicRT"?[data.aws_security_groups.available.ids[0]]:[data.aws_security_groups.available.ids[1]])
  associate_public_ip_address = true
  tags = {
    Name = "Demo-BationHost"
  }
}
