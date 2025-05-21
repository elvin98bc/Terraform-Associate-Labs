#!/bin/bash
# Update and install squid and apache2-utils
apt update && apt install -y squid apache2-utils

# Create password file with username & password non-interactively
htpasswd -cb /etc/squid/passwords proxy_server abc123

# Create squid config directory if not exists
mkdir -p /etc/squid/conf.d/

# Add authentication config to squid conf
cat <<EOF > /etc/squid/conf.d/debian.conf
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm proxy

acl authenticated proxy_auth REQUIRED
http_access allow authenticated
EOF

# Include the new conf.d dir in squid.conf if not included yet
if ! grep -q "^include /etc/squid/conf.d" /etc/squid/squid.conf; then
  echo "include /etc/squid/conf.d/*.conf" >> /etc/squid/squid.conf
fi

# Restart squid service
systemctl restart squid.service