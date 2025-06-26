/*

1. rds tf resource
2. security group
    - 3306 (MySQL)
    - cidr local IP
3. output

*/

resource "aws_db_instance" "tf_rds_instance" {
  allocated_storage      = 10
  db_name                = "terraform_demo"
  identifier             = "nodejs-rds-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "nemish123"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.tf_rds_sg.id] # attach security group
}

# security group
resource "aws_security_group" "tf_rds_sg" {
  name        = "allow_mysql"
  description = "Allow MySQL traffic"
  vpc_id      = "vpc-068f2b9c0e8685f0e"

  ingress {
    description     = "MySQL"
    from_port       = 3306 # MySQL default port
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["171.76.86.6/32"]                # replace with your local IP in CIDR notation
    security_groups = [aws_security_group.tf_ec2_sg.id] # allow traffic from EC2 security group
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
    rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance.endpoint), 0)
}

output "rds_endpoint" {
  value = local.rds_endpoint
  
}

output "rds_username" {
  value = aws_db_instance.tf_rds_instance.username
  
}

output "db_name" {
  value = aws_db_instance.tf_rds_instance.db_name
  
}