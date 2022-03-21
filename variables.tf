variable "aws_region" {
    description = "AWS region where resources will be deployed"
    default = "us-east-1"
    type = string  
}

variable "vpc_name" {
    description = "VPC name"
    type = string
    default = "tfm-myvpc"
}

variable "vpc_cidr_block" {
    description = "VPC cidr block"
    type = string
    default = "10.0.0.0/16"  
}


#Subnet Variables

variable "subnet_cidr_block" {
    description = "Subnet cidr block"
    type = string
    default = "10.0.1.0/24"  
}

variable "avail_zone" {
    description = "avail zone"
    type = string
    default = "us-east-1a"    
}

variable "env_prefix" {
    description = "Env Prefix"
    type = string
    default = "dev"    
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"  
}

