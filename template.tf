provider "aws" {}
resource "aws_instance" "cassandra" {
    ami = "ami-1e299d7e"
    instance_type = "t2.micro"
    tags {
        Name = "cassandra"
    }
   key_name = "debashis1982-new"
    provisioner "remote-exec" {
        inline = [
          "sudo yum -y install java-1.8.0",
          "sudo yum -y remove java-1.7.0-openjdk",
        ]
         connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
    }
    provisioner "file" {
         source = "yum/datastax.repo"
         destination = "/tmp/datastax.repo"
         connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
    }
    provisioner "remote-exec" {
        inline = [
          "sudo mv /tmp/datastax.repo /etc/yum.repos.d/datastax.repo", 
          "sudo yum -y update",
          "sudo yum -y install dsc30",
          "sudo yum -y install cassandra30-tools",
          "sudo service cassandra start"
        ]
         connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
    }
}
