#!/bin/bash

# Wait for initialisation to finish
sleep 60;

# Start the postfix server
sudo postfix start

# Wait until eth0 is configured
while [[ -z `ifconfig | grep eth0` ]];
do
    sleep 10;
done

# Send an e-mail with the IP address to the personal e-mail account 
ifconfig | mailx -s "E-mail subject" personal_email_address@subdomain.domain

# Start the postfix server (in case the previous attempt failed)
sudo postfix start
