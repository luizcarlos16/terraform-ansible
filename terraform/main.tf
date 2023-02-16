#main.tf

#Credenciais
provider "aws" {
  region = "us-west-1"
}

#Definições correspondentes à VPC
resource "aws_vpc" "jvnVPC" {
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  cidr_block           = "172.30.0.0/16"
  tags = {
    Name = "jvnVPC"
  }
}

#Subnet Publica 
resource "aws_subnet" "jvnsn-public" {
  vpc_id            = aws_vpc.jvnVPC.id
  cidr_block        = "172.30.10.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "jvnsn-public"
  }
}

#Subnet privada
resource "aws_subnet" "jvnsn-private" {
  vpc_id            = aws_vpc.jvnVPC.id
  cidr_block        = "172.30.100.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "jvnsn-private"
  }
}

#Definição das tabelas de rotas da VPC para o trafego roteável para internet
resource "aws_route_table" "jvn-public-rt" {
  vpc_id = aws_vpc.jvnVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terragatwey.id
  }
  tags = {
    Name = "jvn-public-rt"
  }
}

#Tabela de rota para subnet privada
resource "aws_route_table" "jvn-private-rt" {
  vpc_id = aws_vpc.jvnVPC.id
  tags = {
    Name = "jvn-private-rt"
  }
}

#Associação de tabela de rota para subnet publica
resource "aws_route_table_association" "jvnr-public-rta" {
  subnet_id      = aws_subnet.jvnsn-public.id
  route_table_id = aws_route_table.jvn-public-rt.id
}

#Associação de tabela de rota para subnet privada
resource "aws_route_table_association" "jvnr-private-rta" {
  subnet_id      = aws_subnet.jvnsn-private.id
  route_table_id = aws_route_table.jvn-private-rt.id
}

#Nat Gateway para conectar subnet privada com internet
resource "aws_nat_gateway" "jvnGW-nat" {
  allocation_id = aws_eip.jvn-nat-eip.id
  subnet_id     = aws_subnet.jvnsn-public.id
  depends_on    = [aws_internet_gateway.terragatwey]
}

#Atribuir EIP para Nat Gateway
resource "aws_eip" "jvn-nat-eip" {
  vpc        = "true"
  depends_on = [aws_internet_gateway.terragatwey]
}

#GATEWAY
resource "aws_internet_gateway" "terragatwey" {
  vpc_id = aws_vpc.jvnVPC.id
  tags = {
    Name = "terragatwey"
  }
}

#Configuração do security group para acesso ssh, http e https
resource "aws_security_group" "jvnSG" {
  name        = "jvnSG"
  vpc_id      = aws_vpc.jvnVPC.id
  description = "Allow incoming HTTP, HTTPS e SSH connections."

  #Inbound
  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS to EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jvnSG"
  }
}

#INSTANCE
resource "aws_instance" "terraform-ansible" {
  ami                         = "ami-09b2a1e33ce552e68"
  instance_type               = "t2.micro"
  disable_api_termination     = "false"
  key_name                    = "terraform-ansible" #Enter your Key Pairs AWS
  vpc_security_group_ids      = [aws_security_group.jvnSG.id]
  subnet_id                   = aws_subnet.jvnsn-public.id
  associate_public_ip_address = "true"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
  }

  tags = {
    Name        = "Terraform Ansible"
    DeployedBy  = "terraform"
    Environment = "Dev"
    Owner       = "Luiz Carlos"
    CreatedAt   = "2023-04-02"
  }
}
