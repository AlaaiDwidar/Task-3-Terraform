
 resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name =var.main_vpc_name 
  }
}

#Create a subnet
#Public Subnet 1a
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_list[0]
  availability_zone = var.AZS[0]
  tags = {
    "Name" = "Web Public Subnet 1b"
  }
}
#Public Subnet 1b
resource "aws_subnet" "web2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_list[1]
  availability_zone = var.AZS[1]
  tags = {
    "Name" = "Web Public Subnet 1c"
  }
}
#Private Subnet 1a
resource "aws_subnet" "web3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_list[2]
  availability_zone = var.AZS[0]
  tags = {
    "Name" = "Web Private Subnet 1b"
  }
}
#Private Subnet 1b
resource "aws_subnet" "web4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_list[3]
  availability_zone = var.AZS[1]
  tags = {
    "Name" = "Web Pirvate Subnet 1c"
  }
}


#Create IGW 
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = var.main_vpc_name
  }
}

#Create Route Table
resource "aws_default_route_table" "main_vpc_default_rt" {

  default_route_table_id = aws_vpc.main.main_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    Name = "my-default-rt"
  }
}


#elastic ip
resource "aws_eip" "eip-nat" {
  vpc = true
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.web.id

  tags = {
    Name = "ngw"
  }
}






resource "aws_route_table_association" "subnet_association1" {
 
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_default_route_table.main_vpc_default_rt.id
}
resource "aws_route_table_association" "subnet_association2" {

  subnet_id      = aws_subnet.web2.id
  route_table_id = aws_default_route_table.main_vpc_default_rt.id
}
