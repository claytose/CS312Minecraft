provider "aws" {
  region = "us-west-2"
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "minecraft_sg" {
  name_prefix = "minecraft-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_ec2" {
  ami           = "ami-04999cd8f2624f834"  # Amazon Linux 2023 (update if needed)
  instance_type = "t2.medium"
  key_name      = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "MinecraftServer"
  }
}

output "public_ip" {
  value = aws_instance.minecraft_ec2.public_ip
}