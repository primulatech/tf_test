#Please note that this code expects SSH key pair to exist in default dir under 
#users home directory, otherwise it will fail

#Create key-pair for logging into EC2 in eu-central-1
resource "aws_key_pair" "master-key" {
#  provider   = aws.region
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


# LOAD BALANCER #
resource "aws_elb" "web" {
  name = "nginx-elb"

  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups = [aws_security_group.elb-sg.id]
  instances       = [aws_instance.nginx1.id, aws_instance.nginx2.id]
 
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
tags = merge(local.common_tags, { Name = "${var.environment_tag}-elb" })
}


#Create and bootstrap EC2 in eu-central-1


resource "aws_instance" "nginx1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.subnet1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo rm /usr/share/nginx/html/index.html",
      "echo '<html><head><title>Blue Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Blue Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx1" })
}

resource "aws_instance" "nginx2" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.subnet2.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
 
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)


  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo rm /usr/share/nginx/html/index.html",
      "echo '<html><head><title>Green Team Server</title></head><body style=\"background-color:#77A032\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Green Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx1" })
}