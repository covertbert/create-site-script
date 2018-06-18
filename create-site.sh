#!/bin/bash

# Colors
GREEN='\033[0;32m'
RESET='\033[0m'

# Functions
get_site_slug() {
    echo "${GREEN}Please enter the slug for the site you wish to create${RESET}"
    read -r SITE_SLUG
    check_input_is_correct
}

check_input_is_correct() {
    echo "${GREEN}You have chosen '$SITE_SLUG' as your slug. Are you sure this is correct (y/n)?"
    read -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        create_nginx_config
        create_site_folder
    else
        get_site_slug
    fi
}

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

        ssl_certificate /home/webadmin/letsencrypt/config/live/bertieblackman.co.uk/fullchain.pem;
        ssl_certificate_key /home/webadmin/letsencrypt/config/live/bertieblackman.co.uk/privkey.pem;

        if (\$scheme = http) {
            return 301 https://\$server_name\$request_uri;
        }
    }"
    echo "$CONFIG_STRING" > "./test/${SITE_SLUG}.nginx"
    echo "\\n ${RESET} Created NGINX file called $SITE_SLUG"
}

create_site_folder() {
    mkdir -p "/home/$USER/sites/$SITE_SLUG/html"
    echo "\\n ${RESET} Created site directory for $SITE_SLUG"
}

create_symbolic_links() {
    sudo ln -s "/home/webadmin/nginx/$SITE_SLUG.nginx" "/etc/nginx/sites-enabled/$SITE_SLUG.nginx"
    echo "\\n ${RESET} Created symlink to sites_enabled for nginx file"
    
    sudo ln -s "/home/webadmin/sites/$SITE_SLUG/html" "/var/www/html/$SITE_SLUG"
    echo "\\n ${RESET} Created symlink to /var/www for site folder"
}

get_site_slug
