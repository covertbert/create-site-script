#!/bin/bash

SITE_SLUG=$1

create_nginx_config() {
    CONFIG_STRING="server {
        listen 80;
        listen [::]:80;
        listen 443 ssl;
        
        server_name $SITE_SLUG;
        
        root /var/www/html/$SITE_SLUG;
        
        location / {
            auth_basic \"Restricted Content\";
            auth_basic_user_file /etc/nginx/.htpasswd;
        }
        
        location ~*  \.(jpg|jpeg|png|gif|ico|css|js|woff2)$ {
            expires 7d;
        }
        
        ssl_certificate /home/$USER/letsencrypt/config/live/bertieblackman.co.uk/fullchain.pem;
        ssl_certificate_key /home/$USER/letsencrypt/config/live/bertieblackman.co.uk/privkey.pem;
        
        if (\$scheme = http) {
            return 301 https://\$server_name\$request_uri;
        }
    }"
    echo "$CONFIG_STRING" > "/home/$USER/nginx/${SITE_SLUG}.nginx"
    echo "Created NGINX file called $SITE_SLUG"
}

create_site_folder() {
    mkdir -p "/home/$USER/sites/$SITE_SLUG/html"
    echo "<h1>Ready to go</h1>" > "/home/$USER/sites/$SITE_SLUG/html/index.html"
    echo "Created site directory for $SITE_SLUG"
}

create_symbolic_links() {
    sudo ln -s "/home/$USER/nginx/$SITE_SLUG.nginx" "/etc/nginx/sites-enabled/$SITE_SLUG.nginx"
    echo "Created symlink to sites_enabled for nginx file"
    
    sudo ln -s "/home/$USER/sites/$SITE_SLUG/html" "/var/www/html/$SITE_SLUG"
    echo "Created symlink to /var/www for site folder"
}

create_site() {
    create_nginx_config
    create_site_folder
    create_symbolic_links
}

create_site
