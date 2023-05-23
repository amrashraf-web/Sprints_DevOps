#!/bin/bash

## First Will Make Function To Install Nodejs 14.x
install_node_js() {
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

## Second Will Make Function To Create an IP configuration file for the local machine to use static address rather than DHCP

Create_IP_Configuration() {
    # My Current Ip Address is 10.0.2.15 , my Dns Server is [192.168.1.1,172.20.10.1] , my routes (gateway) is 10.0.2.2 >>>> i got all from ifconfig
    # enp0s3 My Interface Name
    # i will make command to edit the file with sudo then put the configuration code
    sudo tee /etc/netplan/01-network-manager-all.yaml <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp0s3:
      dhcp4: false
      dhcp6: false
      addresses: [10.0.2.15/24]
      routes:
        - to: default
          via: 10.0.2.2
      nameservers:
          addresses: [192.168.1.1,172.20.10.1]
EOF
    sudo netplan apply
    sudo systemctl restart NetworkManager
}

## Third Function For Creating User node

create_user_node() {
    sudo adduser node
}

## Forth Function To Retrieve the IP address using a RE and store it in a variable

retrieve_ip() {
    IP_ADDRESS=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
}

## Fifth Function To Install Postgres 

install_postgres(){
    sudo apt-get update
    sudo apt-get install postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sudo systemctl status postgresql
    sudo -u postgres createuser --interactive
    sudo -u postgres createdb my_node
    psql -U postgres -d my_node << EOF
CREATE DATABASE my_node;
    CREATE USER my_node WITH ENCRYPTED PASSWORD 'my_node';
    GRANT ALL PRIVILEGES ON DATABASE my_node TO my_node;
EOF
echo "Table created successfully"
}


## Sixth Function To Clone The Repo To My Folder

clone_repo() {
    git clone https://github.com/omarmohsen/pern-stack-example.git
}

## Seventh Function To Run UI tests in a coprocess

ui_tests() {
    cd pern-stack-example
    cd ui
    sudo apt install npm
    npm run test 
}

## Eighth Function To Build UI 

build_UI() {
    npm install
    npm run build
}

## Ninth Function To modify the api/webpack.config.js file to add an environment entry called demo by adding node environment variables within the if statement

modify_environment() {
    cd ..
    cd api
    sed -i '/if (env === "demo") {/a\    process.env.HOST = "'"$IP_ADDRESS"'";\n    process.env.PGUSER = "my_node";\n    process.env.PGPASSWORD = "my_node";\n    process.env.PGHOST = "'"$IP_ADDRESS"'";\n    process.env.PGPORT = "5432";\n    process.env.PGDATABASE = "my_node";' webpack.config.js
    ENVIRONMENT=demo npm run build
}

## Tenth Function To Packaging/starting the application

run_app() {
    cd ..
    cp -r api/dist/* .
    cp api/swagger.css .
    node api.bundle.js
}

install_node_js
echo "Done Installed Nodejs 14.x SuccessFully"
Create_IP_Configuration
echo "Done  Created IP Configuration SuccessFully"
create_user_node
echo "Done Created User Node SuccessFully"
retrieve_ip
echo "Done Retrieve TP SuccessFully , Your IP Address is : $IP_ADDRESS"
install_postgres
echo "Done Installed Postgres And Created Database SuccessFully"
clone_repo
echo "Done Clone The Project SuccessFully"
ui_tests
echo "Done Tested UI SuccessFully"
build_UI
echo "Done Built UI SuccessFully"
modify_environment
echo "Done Modified The Environment and Called it By demo SuccessFully"
run_app
echo "Your App Run SuccessFully Now"