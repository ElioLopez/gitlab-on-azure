locals {
custom_data = <<CUSTOM_DATA
#!/bin/bash
echo "updating instance and installing docker"
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#apt-cache policy docker-ce
sudo apt -y install docker-ce
sudo systemctl status docker
sudo usermod -aG docker azureuser
echo "installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
cd /home/azureuser
mkdir gitlab
docker-compose up -d
CUSTOM_DATA
}

#outputs from this script could be seen on the instance on /var/log/cloud-init-output.log
