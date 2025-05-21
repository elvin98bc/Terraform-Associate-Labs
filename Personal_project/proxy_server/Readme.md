### Installing Squid & Apache Utils
`sudo apt update && sudo apt install -y squid apache2-utils`

### Create a password for Squid
`cd /etc/squid`
`sudo htpasswd -c ./passwords my_username`

### Configure Squid to use the password file
`sudo vi /etc/squid/conf.d/debian.conf`
```
...
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm proxy

acl authenticated proxy_auth REQUIRED
http_access allow authenticated
```

### Restart Squid using systemctl
`sudo systemctl restart squid.service`

### Check squid status
`sudo systemctl status squid`

### youtube link
`https://www.youtube.com/watch?v=8V1f8bAKDYo`