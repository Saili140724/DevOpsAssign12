provider "aws" {
  region = "us-east-1"  # Adjust region as needed
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Use your public SSH key; generate if needed
}

resource "aws_security_group" "swarm_sg" {
  name        = "swarm_sg"
  description = "Allow SSH and Docker Swarm traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict to your IP for security
  }

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Swarm control plane
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Swarm gossip
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # VXLAN overlay
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "manager" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS (us-east-1); adjust for your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.swarm_sg.name]
  tags = {
    Name = "Swarm-Manager"
  }
}

resource "aws_instance" "worker_a" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.swarm_sg.name]
  tags = {
    Name = "Swarm-Worker-A"
  }
}

resource "aws_instance" "worker_b" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.swarm_sg.name]
  tags = {
    Name = "Swarm-Worker-B"
  }
}
