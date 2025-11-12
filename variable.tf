# ------------------------------
# AWS Provider Variables
# ------------------------------
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

# ------------------------------
# EC2 Configuration Variables
# ------------------------------
variable "instance_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-03695d52f0d883f65"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name to access EC2"
  type        = string
  default     = "vpc"
}

variable "vpc_security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
  default     = "sg-0fb18b7adb2c97987"
}

# ------------------------------
# MySQL Configuration Variables
# ------------------------------
variable "mysql_root_password" {
  description = "Root password for MySQL container"
  type        = string
  sensitive   = true
  default     = "root123"
}

variable "mysql_database_name" {
  description = "Database name to create in MySQL"
  type        = string
  default     = "testdb"
}

# ------------------------------
# Tags
# ------------------------------
variable "instance_name" {
  description = "Tag name for EC2 instance"
  type        = string
  default     = "Terraform-MySQL-Instance"
}
