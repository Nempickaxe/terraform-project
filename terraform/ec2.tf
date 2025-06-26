/*

1. Create an EC2 instance
2. new security group
    - 22 (SSH)
    - 443 (HTTPS)
    - 3000 (NodeJS) // ip:3000
*/

resource "aws_instance" "tf_ec2_instance" {
  ami           = "ami-020cba7c55df1f615" # ubuntu image in us-east-1
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.tf_ec2_sg.id ] # attach security group
  key_name = "terraform-ec2"
  depends_on = [ aws_s3_bucket.tf_s3_bucket ]

  tags = {
    Name = "NodeJS-server"
  }

}

# security group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "nodejs-server-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-068f2b9c0e8685f0e"

    ingress {
        description = "TLS from VPC"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #allow all IPs
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "NodeJS"
        from_port   = 3000 #for nodejs server
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
}