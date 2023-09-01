# -----------------------------------------step 1 provider-----------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# -----------------------------------------step 2 provider configuration-----------------------------------------

 provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  # I am using AWS CLI for using access and secret key
}

# -----------------------------------------step 3  resource-----------------------------------------

#  i want to create instances for Auto Scaling Group just so i don't use this (i use aws provider and configuration) 

# Now cerate ec2 instance:

# resource "aws_instance" "asg_s" {
#   ami = "ami-03f65b8614a860c29"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "asg_server"
#   }
# }





# -----------------------------------------Define the VPC  -----------------------------------------
resource "aws_vpc" "asg_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}





#  ----------------------------------------- Define a subnet within the VPC -----------------------------------------



# Define the subnet in us-west-2
resource "aws_subnet" "asg_subnet" {
  vpc_id                  = aws_vpc.asg_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a" # Choose the desired availability zone in us-west-2
  map_public_ip_on_launch = true
}



# ----------------------------------------- Create an Auto Scaling Group -----------------------------------------


# Create an Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "ec2_asg"
  launch_configuration = aws_launch_configuration.asg_launch_cfg.name
  min_size             = 1
  max_size             = 5
  desired_capacity     = 1
  availability_zones   = ["us-west-2a", "us-west-2b"] # Specify the availability zones in us-west-2
}

# -----------------------------------------Create an aws launch configuration -----------------------------------------

# Create an AWS Launch Configuration
resource "aws_launch_configuration" "asg_launch_cfg" {
  name_prefix   = "ec2-lc-"
  image_id      = "ami-03f65b8614a860c29"  # Replace with a valid AMI ID in us-west-2
  instance_type = "t2.micro"
  security_groups             = [aws_security_group.allow_tls.id]
  key_name                   =  "${aws_key_pair.key_tf.key_name}"
  # Additional instance configuration options can be added here.
}