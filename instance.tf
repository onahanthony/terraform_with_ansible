resource "aws_instance" "app-server1" {
  instance_type               = "t2.micro"
  ami                         = "ami-053b0d53c279acc90"
  key_name                    = "my-key"
  vpc_security_group_ids      = [aws_security_group.http-sg.id]
  subnet_id                   = aws_subnet.public-sb1.id
  associate_public_ip_address = true
  tags = {
    Name = "app-server-1"
  }
  provisioner "remote-exec" {
    inline = ["echo 'wait until SSH is ready'"]
    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.app-server1.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.app-server1.public_ip}, --private-key ${local.private_key_path} main.yaml"
  }
}
locals {
  private_key_path = "~/my-key.pem"
  ssh_user         = "ubuntu"
}
output "ec2_global_ips" {
  value = aws_instance.app-server1.public_ip
}


resource "aws_ami_from_instance" "my-ami" {

  name               = "app-server1_ami"
  source_instance_id = aws_instance.app-server1.id
}

resource "aws_instance" "app-server2" {
  instance_type               = "t2.micro"
  ami                         = aws_ami_from_instance.my-ami.id
  subnet_id                   = aws_subnet.public-sb1.id
  vpc_security_group_ids      = [aws_security_group.http-sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "app-server-2"
  }
}
