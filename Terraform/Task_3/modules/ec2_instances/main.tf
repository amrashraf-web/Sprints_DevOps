data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}




resource "aws_instance" "public_instance_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.public_security_group_id]
  associate_public_ip_address = true
  key_name      = "amora"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo bash -c 'echo \"server {",
      "    listen 80;",
      "    location / {",
      "        proxy_pass http://${var.private_load_balancer_dns};",
      "    }",
      "}\" > /etc/nginx/sites-available/default'",
      "sudo systemctl restart nginx",
    ]
  }





  tags = {
    Name = "Public_Nginx_1"
  }
}

resource "aws_instance" "public_instance_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.public_security_group_id]
  associate_public_ip_address = true
  key_name      = "amora"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo bash -c 'echo \"server {",
      "    listen 80;",
      "    location / {",
      "        proxy_pass http://${var.private_load_balancer_dns};",
      "    }",
      "}\" > /etc/nginx/sites-available/default'",
      "sudo systemctl restart nginx",
    ]
  }



  tags = {
    Name = "Public_Nginx_2"
  }
}



resource "aws_instance" "private_instance_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.private_security_group_id]
  key_name      = "amora"

  user_data = <<-EOT
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo echo '<p>Hello From Amr Ashraf ( Private Apache 1) </p>' > /var/www/html/index.html
              EOT
  tags = {
    Name = "Private_Apache_1"
  }
}

resource "aws_instance" "private_instance_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.private_security_group_id]
  key_name      = "amora"
  user_data = <<-EOT
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo echo '<p>Hello From Amr Ashraf ( Private Apache 2) </p>' > /var/www/html/index.html
              EOT
  tags = {
    Name = "Private_Apache_2"
  }
}


resource "null_resource" "print_ips" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "1 - public-ip1 ${aws_instance.public_instance_1.public_ip}" >> all-ips.txt
      echo "2 - public-ip2 ${aws_instance.public_instance_2.public_ip}" >> all-ips.txt
      echo "3 - private-ip1 ${aws_instance.private_instance_1.private_ip}" >> all-ips.txt
      echo "4 - private-ip2 ${aws_instance.private_instance_2.private_ip}" >> all-ips.txt
    EOT
  }
}


resource "aws_lb_target_group_attachment" "public_attachment_1" {
  target_group_arn = var.pub_tg_rg
  target_id        = aws_instance.public_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "public_attachment_2" {
  target_group_arn = var.pub_tg_rg
  target_id        = aws_instance.public_instance_2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "private_attachment_1" {
  target_group_arn = var.pvt_tg_rg
  target_id        = aws_instance.private_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "private_attachment_2" {
  target_group_arn = var.pvt_tg_rg
  target_id        = aws_instance.private_instance_2.id
  port             = 80
}