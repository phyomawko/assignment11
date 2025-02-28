resource "aws_route_table" "ingress_route_table" {
  vpc_id = aws_vpc.application_vpc.id
  depends_on = [data.aws_networkfirewall_firewall.fw_data]
  
  route {
    cidr_block      = "10.1.1.0/24"
    vpc_endpoint_id = tolist(data.aws_networkfirewall_firewall.fw_data.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }
  
  tags = {
    Name = "ingress-route-table"
  }
}
resource "aws_route_table_association" "igw_route_table_association" {
  gateway_id     = aws_internet_gateway.ass11_igw.id
  route_table_id = aws_route_table.ingress_route_table.id
}

resource "aws_route_table" "firewall_rt" {
    vpc_id = aws_vpc.application_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ass11_igw.id
  
}
}
resource "aws_route_table_association" "firewall_rt_association" {
    subnet_id = aws_subnet.firewall_subnet.id
    route_table_id = aws_route_table.firewall_rt.id
}

resource "aws_route_table" "application_rt" {
    vpc_id = aws_vpc.application_vpc.id
    depends_on = [aws_networkfirewall_firewall.fw, data.aws_networkfirewall_firewall.fw_data]
    route {
        cidr_block = "0.0.0.0/0"
        vpc_endpoint_id = tolist(data.aws_networkfirewall_firewall.fw_data.firewall_status[0].sync_states)[0].attachment[0].endpoint_id

  
}
}

resource "aws_route_table_association" "app_subnet_association" {
    subnet_id = aws_subnet.application_subnet.id
    route_table_id = aws_route_table.application_rt.id
}
