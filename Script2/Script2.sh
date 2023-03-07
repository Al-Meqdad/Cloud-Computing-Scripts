#!/bin/env bash

# Log file name with current date
LOG_FILE=install_$(date +"%Y-%m-%d").log

# Function to log messages to the log file
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >> $LOG_FILE
}

# Clone the repository
log "Cloning the SimpleApacheApp repository from GitHub"
git clone https://github.com/mkassaf/SimpleApacheApp.git /tmp/webapp

# Check if Apache 2 is installed
if ! command -v apache2 &> /dev/null
then
    log "Installing Apache 2"
    sudo apt-get update >> $LOG_FILE
    sudo apt-get install apache2 -y >> $LOG_FILE
else
    log "Apache 2 is already installed"
fi

# Move website pages to /var/www/SimpleApp
log "Moving website pages to /var/www/SimpleApp"
sudo mkdir -p /var/www/SimpleApp
sudo cp -r /tmp/webapp/App/* /var/www/SimpleApp

# Move config file to /etc/apache2/sites-available
log "Moving config file to /etc/apache2/sites-available"
sudo cp /tmp/webapp/simpleApp.conf /etc/apache2/sites-available/

# Disable default config and enable new config
log "Disabling default Apache config and enabling new config"
sudo a2dissite 000-default >> $LOG_FILE
sudo a2ensite simpleApp >> $LOG_FILE
sudo systemctl restart apache2 >> $LOG_FILE

# Verify installation
log "Verifying installation by checking status code of the website"
if curl -I http://localhost | grep -q "HTTP/1.1 200 OK"; then
    log "Website is working as expected"
else
    log "Website is not working as expected"
fi

# Remove cloned repository
log "Removing cloned repository from /tmp/webapp"
sudo rm -rf /tmp/webapp

# Add cronjob to update website daily at midnight
log "Adding cronjob to update website daily at midnight"
(crontab -l 2>/dev/null; echo "0 0 * * * git -C /var/www/SimpleApp pull origin main") | crontab -

# Final message
log "Installation completed successfully"
