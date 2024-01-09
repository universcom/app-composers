#!/bin/bash

apt update -y 
apt install ansible pwgen unzip

ansible --version

apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt update -y

apt install docker.io -y
apt install docker-compose -y

docker --version

docker-compose --version


sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["https://docker.iranserver.com "],
  "registry-mirrors": ["https://docker.iranserver.com "]
}
EOF'


wget https://github.com/ansible/awx/archive/17.1.0.zip 

unzip 17.1.0.zip
rm 17.1.0.zip

secret=`pwgen -N 1 -s 40`

sed -i 's/admin_user/#admin_user/g' awx-17.1.0/installer/inventory

echo "admin_user=admin" >> awx-17.1.0/installer/inventory
echo "admin_password=password" >> awx-17.1.0/installer/inventory
echo "secret_key=$secret" >> awx-17.1.0/installer/inventory

ansible-playbook -i awx-17.1.0/installer/inventory awx-17.1.0/installer/install.yml