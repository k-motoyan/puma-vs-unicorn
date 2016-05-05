#
# Variables.
#

variable "DB_USER" {}
variable "DB_PASS" {}

#
# Basic information.
#

provider "aws" {
  region = "ap-northeast-1"
}

#
# Vpc.
#

resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "false"
  enable_dns_hostnames = "false"
  tags {
    Name = "puma-vs-unicorn-vpc"
  }
}

#
# Internet gateway.
#

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = ["aws_vpc.vpc"]
}

#
# Subnet groups.
#

resource "aws_subnet" "web-a" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.0.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "web-c" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "db-a" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "db-c" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-northeast-1c"
}

#
# Route table.
#

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "web-a" {
  subnet_id = "${aws_subnet.web-a.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}


resource "aws_route_table_association" "web-c" {
  subnet_id = "${aws_subnet.web-c.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

#
# Security groups.
#

resource "aws_security_group" "web-security" {
  name = "web-security"
  description = "web server security"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-security" {
  name = "db-security"
  description = "database server security"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.web-a.cidr_block}", "${aws_subnet.web-c.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${aws_subnet.web-a.cidr_block}", "${aws_subnet.web-c.cidr_block}"]
  }
}

#
# EC2 instances.
#

resource "aws_instance" "puma-vs-unicorn-a01" {
  ami = "ami-a21529cc"
  instance_type = "t2.micro"
  key_name = "aws-test"
  vpc_security_group_ids = [
    "${aws_security_group.web-security.id}"
  ]
  subnet_id = "${aws_subnet.web-a.id}"
  associate_public_ip_address = "true"
  root_block_device = {
    volume_type = "gp2"
    volume_size = "20"
  }
  tags {
    Name = "puma-vs-unicorn-a01"
  }
}

#
# RDS subnets.
#

resource "aws_db_subnet_group" "db-subnets" {
  name = "db-subnets"
  description = "database subnets"
  subnet_ids = ["${aws_subnet.db-a.id}", "${aws_subnet.db-c.id}"]
  tags {
    Name = "db-subnets"
  }
}

#
# RDS instances.
#

resource "aws_db_instance" "puma-vs-unicorn-a01" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "9.5.2"
  instance_class         = "db.t2.micro"
  multi_az               = "0"
  availability_zone      = "ap-northeast-1a"
  publicly_accessible    = "0"
  name                   = "puma_vs_unicorn"
  username               = "${var.DB_USER}"
  password               = "${var.DB_PASS}"
  db_subnet_group_name   = "${aws_db_subnet_group.db-subnets.name}"
  parameter_group_name   = "default.postgres9.5"
  vpc_security_group_ids = ["${aws_security_group.db-security.id}"]
}

#
# Output data.
#

output "public ip of puma-vs-unicorn-a01" {
  value = "${aws_instance.puma-vs-unicorn-a01.public_ip}"
}

output "database endpoint of puma-vs-unicorn-a01" {
  value = "${aws_db_instance.puma-vs-unicorn-a.endpoint}"
}