provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-key"
  public_key = file("<your_file_location>")
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
  ami           = "ami-0c101f26f147fa7fd" # Amazon Linux 2023
  instance_type = "t2.medium"
  key_name      = aws_key_pair.minecraft_key.key_name

  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "MinecraftServer"
  }
}
