echo �***********�
echo �*** MSSQL DataBase Setup ***�
echo �*** Created by Christian Olsen ***�
echo �*** Version 6 ***�
echo �***********�
echo � �

#Update Server
echo �****************************��
echo �*** Updating and upgrading Ubuntu Server***��
echo �****************************��
sudo apt update -y
sudo apt upgrade -y
echo �****************************�
echo �*** Updating and upgrading Ubuntu Server - Done***��
echo �****************************�
echo � �
#Install MSSQL Server

echo �***************��
echo �*** Installing MSSQL Server - Start  ***��
echo �****************�
echo � �
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list)"

sudo apt-get update -y
sudo apt-get install -y mssql-server

sudo /opt/mssql/bin/mssql-conf setup accept-eula

echo �****************************��
echo �*** UFW Setup Starting ***�
echo �****************************��
echo � �

#Setup UFW
sudo apt install ufw -y
sudo ufw status
sudo ufw allow 22
sudo ufw allow 1433
sudo ufw enable


echo �****************************��
echo �*** UFW Setup Done ***�
echo �****************************�
echo � �
sudo systemctl status mssql-server --no-pager

#Install MSSQL Command Line
echo � �
echo �***************�
echo �*** Installing MSSQL Command Line - Start  ***�
echo �****************�

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

sudo apt-get update -y
sudo apt-get install mssql-tools unixodbc-dev -y

sudo apt-get update
sudo apt-get install mssql-tools

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

source ~/.bashrc

echo � �

echo �***************�
echo �*** Installing MSSQL Command Line - Done  ***�
echo �****************�

echo � �

# Fix Ubuntu 18.04 MSSQL Compatibility
echo �***************�
echo �*** Installing Ubuntu 18.04 + MSSQL Fix - Start  ***�
echo �****************�

sudo systemctl stop mssql-server

mkdir /etc/systemd/system/mssql-server.service.d/
touch /etc/systemd/system/mssql-server.service.d/override.conf

cat <<EOT >> /etc/systemd/system/mssql-server.service.d/override.conf
[Service]
Environment="LD_LIBRARY_PATH=/opt/mssql/lib"
EOT

sudo ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /opt/mssql/lib/libssl.so
sudo ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /opt/mssql/lib/libcrypto.so

sudo systemctl daemon-reload

sudo systemctl start mssql-server

echo � �

echo �***************�
echo �*** Installing Ubuntu 18.04 + MSSQL Fix - Done ***�
echo �****************�

echo � �

echo �***************��
echo �*** Database Ubuntu Setup - Done ***��
echo �*** Important: Manually import the DB-file through Azure Data Studio to this new server ***��
echo �****************��



