#!/bin/bash

## First Function For Creating User node
create_user_node() {
    echo "Current User is : "
    whoami
    sudo adduser node
    sudo adduser node sudo
    sudo su - node << EOF
    echo "Current User Now is : "
    whoami
EOF

}

## Second Will Make Function To Install Nodejs 14.x


install_node_js() {
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

## Third Will Make Function To Create an IP configuration file for the local machine to use static address rather than DHCP

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
      addresses: [10.0.2.14/24]
      routes:
        - to: default
          via: 10.0.2.2
      nameservers:
          addresses: [192.168.1.1,172.20.10.1]
EOF
    sudo netplan apply
    sudo systemctl restart NetworkManager
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
    sudo -u postgres psql -c "CREATE USER Amr_US WITH PASSWORD 'my_node';"
    sudo -u postgres createdb Amr_DB
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE Amr_DB TO Amr_US;"
}


## Sixth Function To Clone The Repo To My Folder

clone_repo() {
    git clone https://github.com/omarmohsen/pern-stack-example.git
}

## Seventh Function To Run UI tests in a coprocess

ui_tests() {
    cd /home/amr/Project_Bash/pern-stack-example/ui || exit
    sudo apt install npm
    npm run test 
}

## Eighth Function To Build UI 

build_UI() {
    cd /home/amr/Project_Bash/pern-stack-example/ui || exit
    npm install
    npm run build
}

# Ninth Function To modify the api/webpack.config.js file to add an environment entry called demo by adding node environment variables within the if statement

modify_environment(){
    cd /home/amr/Project_Bash/pern-stack-example/api || exit
    sed -i "s/else if /else if (environment === 'demo') {\\n    ENVIRONMENT_VARIABLES = { \\n   'process.env.HOST' : JSON.stringify('10.0.2.14'),\\n   'process.env.USER' : JSON.stringify('Amr_US'),\\n   'process.env.DB' : JSON.stringify('Amr_DB'),\\n   'process.env.PASSWORD' : JSON.stringify('my_node'),\\n   'process.env.DIALECT' : JSON.stringify('postgres'),\\n   'process.env.PORT' : JSON.stringify('2023'),\\n   'process.env.PG_CONNECTION_STR': JSON.stringify('postgres:\/\/Amr_US:my_node@10.0.2.14:5432\/Amr_DB')\\n   };\\n} else if /g" webpack.config.js
    npm install webpack 
    npm install pg
    ENVIRONMENT=demo npm run build
}


## Tenth Function To Packaging/starting the application

run_app() {
    cd /home/amr/Project_Bash/pern-stack-example
    cp api/swagger.css .
    cp -r api/dist/* .
    node api.bundle.js
}
create_user_node
echo "Done Created User Node SuccessFully"
sleep 5
install_node_js
echo "Done Installed Nodejs 14.x SuccessFully"
sleep 5
Create_IP_Configuration
echo "Done  Created IP Configuration SuccessFully"
sleep 5
retrieve_ip
echo "Done Retrieve TP SuccessFully , Your IP Address is : $IP_ADDRESS"
sleep 5
install_postgres
echo "Done Installed Postgres And Created Database SuccessFully"
sleep 5
clone_repo
echo "Done Clone The Project SuccessFully"
sleep 5
ui_tests
echo "Done Tested UI SuccessFully"
sleep 5
build_UI
echo "Done Built UI SuccessFully"
sleep 5
modify_environment
echo "Done Modified The Environment and Called it By demo SuccessFully"
sleep 5
run_app
echo "Your App Run SuccessFully Now"
