#Note: This is the "cleaned"-version of the script, in which user login information and github repo-links have been removed.

#IMPORTANT! INSERT THE DATABASE IP, USER AND PASSWORD BELOW!
THE_DATABASE_IP= [DATABASE IP]
USER=[DATA BASE USER NAME]
PASSWORD=[DATABASE USER PASSWORD]

echo "**************************************"
echo THE_DATABASE_IP ENTERED: $THE_BACKEND_IP 
echo USER ENTERED: $USER
echo PASSWORD ENTERED: $PASSWORD
echo "**************************************"


echo �****************************�
echo �*** Backend Setup Script running!***�
echo �*** Not fully automatic yet, so please yes and press enter if asked for anything***�
echo �*** Created by Christian Olsen***�
echo �*** Version 13***�
echo �****************************�


#Update Server
echo �****************************�
echo �*** Updating and upgrading Ubuntu Server***�
echo �****************************�
sudo apt update -y
sudo apt upgrade -y
echo �****************************�
echo �*** Updating and upgrading Ubuntu Server - Done***�
echo �****************************�

#Git clone project
echo �****************************�
echo �*** Git Cloning the Project - Start***�
echo �****************************�

sudo git clone [GITHUB LINK TO BACKEND PROJECT REPO] /var/www/official.poc.NatDamv2Backend

echo �****************************�
echo �*** Git Cloning the Project - Done ***�
echo �****************************�


#Install and setup nginx
echo �****************************�
echo �*** Nginx Setup - Installing ***�
echo �****************************�

sudo apt install nginx -y
sudo service nginx start
#sudo service nginx status

echo �****************************�
echo �*** Nginx Setup - Removing old Default ***�
echo �****************************�
#Remove default NGinx server block 
sudo rm /etc/nginx/sites-available/default

echo �****************************�
echo �*** Nginx Setup - Creating new Default file and server block ***�
echo �****************************�
#Create new file
touch /etc/nginx/sites-available/default

# Insert the server block
cat <<EOT >> /etc/nginx/sites-available/default
server {
listen 80;
location / {
proxy_pass http://localhost:5000;
proxy_http_version 1.1;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection keep-alive;
proxy_set_header Host \$http_host;
proxy_cache_bypass \$http_upgrade;
}
}
EOT

echo �****************************�
echo �*** Nginx Setup - Reloading and Restarting ***�
echo �****************************�

#Reload and restart the nginx service
sudo nginx -t
sudo nginx -s reload
sudo service nginx start
#sudo service nginx status

echo �****************************�
echo �*** Nginx Setup - Done ***�
echo �****************************�

echo �****************************�
echo �*** UFW Setup Starting ***�
echo �****************************�
#Setup UFW
sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx Full'
sudo ufw enable 

echo �****************************�
echo �*** UFW Setup Done ***�
echo �****************************�

#Install .Net Core

echo �****************************�
echo �*** .Net Core Setup Starting ***�
echo �****************************�

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe -y
sudo apt install apt-transport-https -y
sudo apt update -y
sudo apt install dotnet-sdk-2.2

echo �****************************�
echo �*** .Net Core Setup Done ***�
echo �****************************�

echo �****************************�
echo �*** Azure CLI Setup Starting ***�
echo �****************************�

#Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login -u [AZ Username] -p [AZ Password]

echo �****************************�
echo �*** Azure CLI Setup Done ***�
echo �****************************�

echo �****************************�
echo �*** Editing .Net Core Project Startup.cs-file ***�
echo �****************************�

#Disable HttpsRedirection
sudo sed -i 's/app.UseHttpsRedirection();/\/\/app.UseHttpsRedirection();/' /var/www/official.poc.NatDamv2Backend/NatDamV2BackendCore2/Startup.cs

echo �****************************�
echo �*** Editing Done ***�
echo �****************************�

echo �****************************�
echo �*** Editing .Net Core Project Metadatacontroller.cs-file ***�
echo �****************************�

sudo sed -i 's/using (var context = new Context(Configuration\[\"DamsSqlConnection\"\]))/using (var context = new Context("Server=tcp:'$THE_DATABASE_IP',1433;Initial Catalog=nm-dams-db-dev;User ID='$USER';Password='$PASSWORD';Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"))/' /var/www/official.poc.NatDamv2Backend/NatDamV2BackendCore2/Controllers/MetadataController.cs

echo �****************************�
echo �*** Editing Done ***�
echo �****************************�


echo �****************************�
echo �*** Editing .Net Core Project Context.cs-file ***�
echo �****************************�

#Insert the new SQLConnection
sudo sed -i '42 a optionsBuilder.UseSqlServer("Server=tcp:'$THE_DATABASE_IP',1433;Initial Catalog=nm-dams-db-dev;User ID='$USER';Password='$PASSWORD';Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;");' /var/www/official.poc.NatDamv2Backend/NatDamV2BackendCore2/Models/Context.cs


#Disable original Azure SQL Connection
sudo sed -i 's/optionsBuilder.UseSqlServer(Startup.Configuration\[\"DamsSqlConnection\"\]);/\/\/optionsBuilder.UseSqlServer(Startup.Configuration\[\"DamsSqlConnection\"\]);/' /var/www/official.poc.NatDamv2Backend/NatDamV2BackendCore2/Models/Context.cs

echo �****************************�
echo �*** Editing Done ***�
echo �****************************�


echo �****************************�
echo �*** Starting the .Net Core Server ***�
echo �****************************�

# Run dot net core server
dotnet run --project /var/www/official.poc.NatDamv2Backend/NatDamV2BackendCore2/
