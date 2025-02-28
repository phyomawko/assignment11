resource "aws_internet_gateway" "ass11_igw" {
    vpc_id = aws_vpc.application_vpc.id
    tags = {
        Name = "ass11_igw"
    }
  
}