#IMPORTANT! INSERT THE BACKEDN IP BELOW!
THE_BACKEND_IP= [DATABASE IP]

echo "**************************************"
echo Backend_IP ENTERED: $THE_BACKEND_IP 
echo "**************************************"

echo "**************************************"
echo "*** Frontend VueJS Setup - Running ***"
echo "*** Created by Christian Olsen ***"
echo "*** Version 9 ***"
echo "**************************************"

echo "***************************************"
echo "*** Ubuntu Update & Upgrade - Start ***"
echo "***************************************"

#Update and Upgrade
sudo apt update
sudo apt upgrade -y

echo "***************************************"
echo "*** Ubuntu Update & Upgrade - Done ***"
echo "***************************************"

echo "***************************************"
echo "*** NodeJS Download & Install - Start ***"
echo "***************************************"

#Install NodeJS 13
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "***************************************"
echo "*** NodeJS Download & Install - Done ***"
echo "***************************************"

echo "***************************************"
echo "*** Yarn Download & Install - Start ***"
echo "***************************************"

#Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update
sudo apt install yarn

echo "***************************************"
echo "*** Yarn Download & Install - Done ***"
echo "***************************************"


echo "***************************************"
echo "*** Nginx Download, Install & Setup - Start ***"
echo "***************************************"

#Install NginX
sudo apt install nginx -y 
sudo rm /etc/nginx/sites-available/default

# Insert the server block
cat <<EOT >> /etc/nginx/sites-available/default
server {
  listen 8000 default_server; 
  listen $(hostname -I | cut -f1 -d' '):8000 default_server; 
  root /var/www/html/official.poc.NatDamv2Frontend/dist;
  index index.html index.htm index.nginx-debian.html;
  server_name _;
  error_page 404 /index.html;
  location /official.poc.NatDamv2Frontend {
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_max_temp_file_size 0;
    proxy_pass http://$(hostname -I | cut -f1 -d' '):8000;
    proxy_redirect off;
    proxy_read_timeout 240s;
  }
}

EOT

#systemctl status nginx
nginx -t
sudo nginx -s reload

echo "***************************************"
echo "*** Nginx Download, Install & Setup - Done ***"
echo "***************************************"



echo "****************************"
echo "*** UFW Setup Starting ***"
echo "****************************"
#Setup UFW
sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 8000
sudo ufw allow 'Nginx HTTP'
sudo ufw enable 

echo "****************************"
echo "*** UFW Setup Done ***"
echo "****************************"

echo "****************************"
echo "*** Downloading Git Project - Start ***"
echo "****************************"

#Download Git Project
git clone [GITHUB LINK TO FRONTEND PROJECT REPO] /var/www/html/official.poc.NatDamv2Frontend

echo "****************************"
echo "*** Downloading Git Project - Done ***"
echo "****************************"

echo "****************************"
echo "*** Install VueJS project - Start ***"
echo "****************************"

#Setup VueJS Project
cd /var/www/html/official.poc.NatDamv2Frontend
yarn install

#Create the .env-file
cat <<EOT >> .env
{
VUE_APP_API_PATH = "http://$THE_BACKEND_IP/api"
}
EOT

echo "****************************"
echo "*** Install VueJS project - Done ***"
echo "****************************"

echo "****************************"
echo "*** Build VueJS project - Start ***"
echo "****************************"

yarn build --production

echo "****************************"
echo "*** Build VueJS project - Done ***"
echo "****************************"

echo "****************************"
echo "*** SETUP PROCESS COMPLETE ***"
echo "*** Visit the Frontend on $(hostname -I | cut -f1 -d' '):8000 ***"
echo "****************************"

