echo ì***********î
echo ì*** MSSQL DataBase Setup ***î
echo ì*** Created by Christian Olsen ***î
echo ì*** Version 6 ***î
echo ì***********î
echo ì î

#Update Server
echo ì****************************îù
echo ì*** Updating and upgrading Ubuntu Server***îù
echo ì****************************îù
sudo apt update -y
sudo apt upgrade -y
echo ì****************************î
echo ì*** Updating and upgrading Ubuntu Server - Done***îù
echo ì****************************î
echo ì î
#Install MSSQL Server

echo ì***************îù
echo ì*** Installing MSSQL Server - Start  ***îù
echo ì****************î
echo ì î
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list)"

sudo apt-get update -y
sudo apt-get install -y mssql-server

sudo /opt/mssql/bin/mssql-conf setup accept-eula

echo ì****************************îù
echo ì*** UFW Setup Starting ***î
echo ì****************************îù
echo ì î

#Setup UFW
sudo apt install ufw -y
sudo ufw status
sudo ufw allow 22
sudo ufw allow 1433
sudo ufw enable


echo ì****************************îù
echo ì*** UFW Setup Done ***î
echo ì****************************î
echo ì î
sudo systemctl status mssql-server --no-pager

#Install MSSQL Command Line
echo ì î
echo ì***************î
echo ì*** Installing MSSQL Command Line - Start  ***î
echo ì****************î

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

sudo apt-get update -y
sudo apt-get install mssql-tools unixodbc-dev -y

sudo apt-get update
sudo apt-get install mssql-tools

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

source ~/.bashrc

echo ì î

echo ì***************î
echo ì*** Installing MSSQL Command Line - Done  ***î
echo ì****************î

echo ì î

# Fix Ubuntu 18.04 MSSQL Compatibility
echo ì***************î
echo ì*** Installing Ubuntu 18.04 + MSSQL Fix - Start  ***î
echo ì****************î

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

echo ì î

echo ì***************î
echo ì*** Installing Ubuntu 18.04 + MSSQL Fix - Done ***î
echo ì****************î

echo ì î

echo ì***************îù
echo ì*** Database Ubuntu Setup - Done ***îù
echo ì*** Important: Manually import the DB-file through Azure Data Studio to this new server ***îù
echo ì****************îù



