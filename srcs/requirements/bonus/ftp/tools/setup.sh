#!/bin/sh

if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user..."
    
    # Add www-data group since the alpine vsftpd image doesn't have it by default
    addgroup -g 82 -S www-data 2>/dev/null || true
    
    # Create user with home directory as the WordPress volume and primary group www-data
    adduser -h /var/www/html -s /bin/false -G www-data -D "$FTP_USER"
    
    # Set the password
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
    # Add user to the vsftpd userlist
    echo "$FTP_USER" > /etc/vsftpd/vsftpd.userlist
    
    # Fix permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 2775 /var/www/html
fi

echo "Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
