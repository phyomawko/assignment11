resource "aws_subnet" "application_subnet" {
    vpc_id = aws_vpc.application_vpc.id
    cidr_block ="10.1.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-1a"
    tags = {
      Name ="application_subnet"
    }
  
}
resource "aws_subnet" "firewall_subnet" {
    vpc_id = aws_vpc.application_vpc.id
    cidr_block = "10.1.2.0/28"
    availability_zone = "ap-southeast-1a"
    tags = {
      Name = "firewall_subnet"
    }
  

}
