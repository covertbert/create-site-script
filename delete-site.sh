#!/bin/bash

TARGET_SITE=$1

check_if_site_exists() {
    if [ ! -f /etc/nginx/sites-enabled/"$TARGET_SITE" ]; then
        echo "Site not found!"
    else
        delete_target_site    
    fi
}

delete_target_site() {
    rm -rf "/home/$USER/sites/$TARGET_SITE"
    echo "Deleted site folder"

    rm -rf "/home/$USER/nginx/$TARGET_SITE"
    echo "Deleted nginx file"
    
    sudo rm -rf "/etc/nginx/sites_enabled/$TARGET_SITE"
    echo "Deleted nginx sites_enabled symlink"
    
    sudo rm -rf "/var/www/html/$TARGET_SITE"
    echo "Deleted site folder symlink"
}

check_if_site_exists
