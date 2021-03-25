#Please note that this code expects SSH key pair to exist in default dir under 
#users home directory, otherwise it will fail

#Create key-pair for logging into EC2 in eu-central-1
resource "aws_key_pair" "master-key" {
#  provider   = aws.region
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

#Create and bootstrap EC2 in eu-central-1


resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance-type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "terraform_1"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}