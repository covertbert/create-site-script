#!/bin/bash

TARGET_SITE=$1

check_if_site_exists() {
    if [ ! -f /etc/nginx/sites-enabled/"$TARGET_SITE".nginx ]; then
        echo "Site not found!"
    else
        delete_target_site    
    fi
}

delete_target_site() {
    rm -rf "/home/$USER/nginx/$TARGET_SITE.nginx"
    echo "Deleted nginx file"
    
    rm -rf "/home/$USER/sites/$TARGET_SITE"
    echo "Deleted site folder"

    sudo rm -rf "/etc/nginx/sites-enabled/$TARGET_SITE.nginx"
    echo "Deleted nginx sites_enabled symlink"
    
    sudo rm -rf "/var/www/html/$TARGET_SITE"
    echo "Deleted site folder symlink"
}

check_if_site_exists
