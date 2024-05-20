#!/bin/bash

# Function to install Docker and Docker Compose on Ubuntu/Debian
install_docker_ubuntu_debian() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker ${USER}
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version
}

# Function to install Docker and Docker Compose on CentOS/RHEL
install_docker_centos_rhel() {
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ${USER}
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version
}

# Function to install Docker and Docker Compose on Fedora
install_docker_fedora() {
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ${USER}
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version
}

# Function to install Docker and Docker Compose on openSUSE
install_docker_opensuse() {
    sudo zypper install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ${USER}
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version
}

# Detect the Linux distribution and call the appropriate function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        ubuntu|debian)
            install_docker_ubuntu_debian
            ;;
        centos|rhel)
            install_docker_centos_rhel
            ;;
        fedora)
            install_docker_fedora
            ;;
        opensuse|suse)
            install_docker_opensuse
            ;;
        *)
            echo "Unsupported Linux distribution."
            exit 1
            ;;
    esac
else
    echo "Cannot determine the Linux distribution."
    exit 1
fi

# Function to install Metricbeat
install_metricbeat() {
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        sudo apt-get install apt-transport-https
        echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
        sudo apt-get update && sudo apt-get install metricbeat
    elif [[ "$ID" == "centos" || "$ID" == "rhel" ]]; then
        sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
        cat <<EOF | sudo tee /etc/yum.repos.d/elastic-7.x.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
        sudo yum install metricbeat
    else
        echo "Metricbeat installation is not supported on this distribution."
        exit 1
    fi
    sudo systemctl enable metricbeat
    sudo systemctl start metricbeat
}

# Function to install Filebeat
install_filebeat() {
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        sudo apt-get install apt-transport-https
        echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
        sudo apt-get update && sudo apt-get install filebeat
    elif [[ "$ID" == "centos" || "$ID" == "rhel" ]]; then
        sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
        cat <<EOF | sudo tee /etc/yum.repos.d/elastic-7.x.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
        sudo yum install filebeat
    else
        echo "Filebeat installation is not supported on this distribution."
        exit 1
    fi
    sudo systemctl enable filebeat
    sudo systemctl start filebeat
}

# Install Metricbeat and Filebeat
install_metricbeat
install_filebeat

# Configure Metricbeat and Filebeat to connect to the ELK stack
cat <<EOF | sudo tee /etc/metricbeat/metricbeat.yml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
EOF

cat <<EOF | sudo tee /etc/filebeat/filebeat.yml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
EOF

# Restart Metricbeat and Filebeat
sudo systemctl restart metricbeat
sudo systemctl restart filebeat

echo "Docker, Docker Compose, Metricbeat, and Filebeat have been successfully set up."
echo "Please ensure your docker-compose.yml file is correctly configured for the ELK stack."
echo "To start the ELK stack, run: docker-compose up -d"