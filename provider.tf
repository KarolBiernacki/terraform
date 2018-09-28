provider "aws" {
  region     = "eu-central-1"
}

resource "aws_vpc" "terraformVPC" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
    tags {
        Name="terraform"
    }
}
resource "aws_subnet" "PublicSubnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = "${aws_vpc.terraformVPC.id}"
    availability_zone = "eu-central-1a"
}

resource "aws_subnet" "PrivateSubnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = "${aws_vpc.terraformVPC.id}"
    availability_zone = "eu-central-1b"
}
resource "aws_internet_gateway" "terraformIGW" {
    vpc_id = "${aws_vpc.terraformVPC.id}"

}
resource "aws_route_table" "public_access" {
    vpc_id = "${aws_vpc.terraformVPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terraformIGW.id}"
    }
    tags {
        Name = "public_rtb"
        Terraform = "True"
        Enviroment = "Dev"
    }
}
resource "aws_route_table_association" "a" {
    subnet_id = "${aws_subnet.PublicSubnet.id}"
    route_table_id = "${aws_route_table.public_access.id}"
}

