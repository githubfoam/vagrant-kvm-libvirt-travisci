# -*- mode: ruby -*-
# vi: set ft=ruby :
$centos_docker_script = <<SCRIPT
# Install Docker
sudo yum remove docker \
          docker-client \
          docker-client-latest \
          docker-common \
          docker-latest \
          docker-latest-logrotate \
          docker-logrotate \
          docker-engine
sudo yum install -y yum-utils \
            device-mapper-persistent-data \
            lvm2
sudo yum-config-manager \
                --add-repo \
                https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce \
              docker-ce-cli \
              containerd.io
sudo systemctl start docker && sudo docker --version
# Install Terraform
sudo yum install unzip wget -y
wget -q -nc https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
unzip terraform_0.12.18_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
SCRIPT
$ubuntu_docker_script = <<SCRIPT
# Get Docker Engine - Community for Ubuntu
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker --version
# Manage Docker as a non-root user
# https://docs.docker.com/install/linux/linux-postinstall/
sudo groupadd docker && sudo usermod -aG docker vagrant # add user to the docker group
sudo systemctl enable docker
docker --version
# Install Terraform
sudo apt-get install unzip -y
wget -q -nc https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
unzip terraform_0.12.18_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
SCRIPT
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
$ubuntu_docker_build_script = <<SCRIPT
whoami
sudo docker --version
echo "===================================================================================="
# Build from a local build context, using a Dockerfile from stdin
# create a directory to work in
mkdir ~/example && cd ~/example
# create an example file
touch ~/example/somefile.txt
# build an image using the current directory as context, and a Dockerfile passed through stdin
sudo docker build -t myimage:latest -f- . <<EOF
FROM busybox
COPY somefile.txt .
# If you want the command to fail due to an error at any stage in the pipe,
# prepend set -o pipefail && to ensure that an unexpected error prevents the build from inadvertently succeeding.
RUN set -o pipefail && echo "tester bester" | tee -a /etc/sudoers && \
    cat /somefile.txt
EOF
echo "===================================================================================="
# Build context example
mkdir myproject && cd myproject
echo "hello" > hello
echo -e "FROM busybox\nCOPY /hello /\nRUN cat /hello" > Dockerfile
sudo docker build -t helloapp:v1 .
echo "===================================================================================="
# Pipe Dockerfile through stdin
echo -e 'FROM busybox\nRUN echo "hola mundo-1"' | sudo docker build -t holamundo:v1 -
echo "===================================================================================="
sudo docker build -t holamundo:v2 -<<EOF
FROM busybox
RUN echo "hola mundo-2"
EOF
echo "===================================================================================="
# builds an image using a Dockerfile from stdin, and adds the hello.c file from the “hello-world” Git repository on GitHub.
sudo docker build -t hello-world:latest -f- https://github.com/docker-library/hello-world.git <<EOF
FROM busybox
COPY hello.c .
EOF
echo "===================================================================================="
sudo docker build -<<EOF
FROM ubuntu:19.04

# Set multiple labels at once, using line-continuation characters to break long lines
LABEL vendor="ACME Incorporated" \
      com.example.is-beta= \
      com.example.is-production="" \
      com.example.version="0.0.1-beta" \
      com.example.release-date="2015-02-12"

# Always combine RUN apt-get update with apt-get install in the same RUN statement
# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install instructions fail.
RUN apt-get update && apt-get install -y curl \
    nginx \
    git \
 && rm -rf /var/lib/apt/lists/*

RUN echo "hola mundo-2"
EOF
echo "===================================================================================="

sudo docker build -t holamundo:v4 -<<EOF
FROM ubuntu:19.04

# Set multiple labels at once, using line-continuation characters to break long lines
LABEL vendor="ACME Incorporated" \
      com.example.is-beta= \
      com.example.is-production="" \
      com.example.version="0.0.1-beta" \
      com.example.release-date="2015-02-12"

# Always combine RUN apt-get update with apt-get install in the same RUN statement
# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install instructions fail.
RUN apt-get update && apt-get install -y curl \
    nginx \
    git \
 && rm -rf /var/lib/apt/lists/*

RUN echo "hola mundo-4"
EOF
echo "===================================================================================="
SCRIPT
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
$centos_docker_build_script = <<SCRIPT
whoami
sudo docker --version
echo "===================================================================================="
# Build from a local build context, using a Dockerfile from stdin
# create a directory to work in
mkdir ~/example && cd ~/example
# create an example file
touch ~/example/somefile.txt
# build an image using the current directory as context, and a Dockerfile passed through stdin
sudo docker build -t myimage:latest -f- . <<EOF
FROM busybox
COPY somefile.txt .
# If you want the command to fail due to an error at any stage in the pipe,
# prepend set -o pipefail && to ensure that an unexpected error prevents the build from inadvertently succeeding.
RUN set -o pipefail && echo "tester bester" | tee -a /etc/sudoers && \
    cat /somefile.txt
EOF
echo "===================================================================================="
# Build context example
mkdir myproject && cd myproject
echo "hello" > hello
echo -e "FROM busybox\nCOPY /hello /\nRUN cat /hello" > Dockerfile
sudo docker build -t helloapp:v1 .
echo "===================================================================================="
# Pipe Dockerfile through stdin
echo -e 'FROM busybox\nRUN echo "hola mundo-1"' | sudo docker build -t holamundo:v1 -
echo "===================================================================================="
sudo docker build -t holamundo:v2 -<<EOF
FROM busybox
RUN echo "hola mundo-2"
EOF
echo "===================================================================================="
# Pipe Dockerfile through stdin, requires git to be installed on the host
# Operating System: CentOS Linux 7 (Core),bento/centos-7.7
# Docker version 19.03.5, build 633a0ea
# git version 1.8.3.1
# https://forums.docker.com/t/build-with-url-error/48638/2
sudo yum install git -y && sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y && sudo yum swap git git2u -y
# sudo docker build -t hello-world:amd64 https://github.com/docker-library/hello-world/tree/master/amd64/hello-world <<EOF
# sudo docker build -t hello-world:amd64 https://github.com/docker-library/hello-world.git\#:amd64/hello-world <<EOF
# sudo docker build -t hello-world:amd64 https://github.com/docker-library/hello-world/blob/master/amd64/hello-world/Dockerfile <<EOF
# builds an image using a Dockerfile from stdin, and adds the hello.c file from the “hello-world” Git repository on GitHub.
sudo docker build -t hello-world:latest -f- https://github.com/docker-library/hello-world.git <<EOF
FROM busybox
COPY hello.c .
EOF
echo "===================================================================================="
sudo docker build -<<EOF
FROM ubuntu:19.04

# Set multiple labels at once, using line-continuation characters to break long lines
LABEL vendor="ACME Incorporated" \
      com.example.is-beta= \
      com.example.is-production="" \
      com.example.version="0.0.1-beta" \
      com.example.release-date="2015-02-12"

# Always combine RUN apt-get update with apt-get install in the same RUN statement
# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install instructions fail.
RUN apt-get update && apt-get install -y curl \
    nginx \
    git \
 && rm -rf /var/lib/apt/lists/*

RUN echo "hola mundo-2"
EOF
echo "===================================================================================="

sudo docker build -t holamundo:v4 -<<EOF
FROM ubuntu:19.04

# Set multiple labels at once, using line-continuation characters to break long lines
LABEL vendor="ACME Incorporated" \
      com.example.is-beta= \
      com.example.is-production="" \
      com.example.version="0.0.1-beta" \
      com.example.release-date="2015-02-12"

# Always combine RUN apt-get update with apt-get install in the same RUN statement
# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install instructions fail.
RUN apt-get update && apt-get install -y curl \
    nginx \
    git \
 && rm -rf /var/lib/apt/lists/*

RUN echo "hola mundo-4"
EOF
echo "===================================================================================="
SCRIPT
$docker_registry_script = <<SCRIPT
#https://docs.docker.com/registry/deploying/
#Start the registry automatically Customize the published port
# the first part of the -p value is the host port and the second part is the port within the container
docker run -d -p 5001:5000 --name registry-test registry:2
#use the environment variable REGISTRY_HTTP_ADDR to change it,the registry to listen on port 5002 within the container
docker run -d \
-e REGISTRY_HTTP_ADDR=0.0.0.0:5002 \
-p 5001:5002 \
--name registry-test \
registry:2
SCRIPT
Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # vbox template for all vagranth instances
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = 2
  end

  # customize vagrant instance
  config.vm.define "control01" do |dockercluster|
    dockercluster.vm.box = "bento/ubuntu-16.04"
    dockercluster.vm.provider "virtualbox" do |vb|
      vb.name = "control01"
     end
     dockercluster.vm.network "private_network", ip: "172.28.128.12"
     dockercluster.vm.network "forwarded_port", guest: 80, host: 81
     dockercluster.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "deploy.yml"
       ansible.become = true
       ansible.compatibility_mode = "2.0"
       ansible.version = "2.9.2"
     end
     # dockercluster.vm.provision "shell", inline: $ubuntu_docker_script, privileged: false
     # dockercluster.vm.provision "shell", inline: $ubuntu_docker_build_script, privileged: false
     dockercluster.vm.provision "shell", inline: <<-SHELL
     echo "===================================================================================="
                               hostnamectl status
     echo "===================================================================================="
     echo "         \   ^__^                                                                  "
     echo "          \  (oo)\_______                                                          "
     echo "             (__)\       )\/\                                                      "
     echo "                 ||----w |                                                         "
     echo "                 ||     ||                                                         "
     SHELL


  end

  # customize vagrant instance
  config.vm.define "control02" do |dockercluster|
    dockercluster.vm.box = "centos/7"
    dockercluster.vm.network "private_network", ip: "172.28.128.15"
    dockercluster.vm.network "forwarded_port", guest: 80, host: 82
    dockercluster.vm.provider "virtualbox" do |vb|
      vb.name = "control02"
     end
     dockercluster.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "deploy.yml"
       ansible.become = true
       ansible.compatibility_mode = "2.0"
       ansible.version = "2.9.6"
     end
    dockercluster.vm.provision "shell", inline: $centos_docker_script, privileged: false
    # dockercluster.vm.provision "shell", inline: $centos_docker_build_script, privileged: false
    dockercluster.vm.provision "shell", inline: <<-SHELL
    echo "===================================================================================="
                              hostnamectl status
    echo "===================================================================================="
    echo "         \   ^__^                                                                  "
    echo "          \  (oo)\_______                                                          "
    echo "             (__)\       )\/\                                                      "
    echo "                 ||----w |                                                         "
    echo "                 ||     ||                                                         "
    SHELL
  end



end
