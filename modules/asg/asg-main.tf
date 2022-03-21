resource "aws_launch_template" "my-launch-template" {
    name = "giteepag-launch-template"
    image_id = data.aws_ami.latest-amazon-linux-image.id
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t2.micro"    
    key_name = "giteepag-keypair1"
    network_interfaces {
        associate_public_ip_address = true
        subnet_id = var.subnet_id
        security_groups = ["${var.securitygroup}"]
    }
    placement {
        availability_zone = var.avail_zone
    }


    tag_specifications {
        resource_type = "instance"

        tags = {
        Name = "${var.env_prefix}-launch-template"
        }
    }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
 

resource "aws_autoscaling_group" "myasg" {
  #availability_zones = var.avail_zone
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier  = ["${var.subnet_id}"]
  target_group_arns = ["${aws_lb_target_group.mytagetgroup.arn}"]

  launch_template {
    id      = aws_launch_template.my-launch-template.id
    version = "$Latest"
  }
}

resource "aws_lb" "mynetworklb" {
  name               = "${var.env_prefix}-load-balancer"
  internal           = true
  load_balancer_type = "network"
  subnet_mapping {
    subnet_id = var.subnet_id
  }

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "mytagetgroup" {
  name     = "${var.env_prefix}-targetgroup"
  port     = "123"
  protocol = "UDP"
  vpc_id   = var.vpc_id
  target_type = "instance"  
}

resource "aws_lb_listener" "mynlblistener" {
  load_balancer_arn = "${aws_lb.mynetworklb.arn}"
  port              = "123"
  protocol          = "UDP"
  default_action {
    target_group_arn = "${aws_lb_target_group.mytagetgroup.arn}"
    type             = "forward"
  }
}