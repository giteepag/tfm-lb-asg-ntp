resource "aws_vpc" "tfm-myvpc" {
  cidr_block = var.myvpc-cidr-block
  instance_tenancy = "default"

  tags = {
    Name = var.myvpc-name
  }

}