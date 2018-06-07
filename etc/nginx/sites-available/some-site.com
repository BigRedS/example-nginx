# This is a basic site available both over HTTP and HTTPS, proxied back to port
# 8080 on the localhost.
#
# Note that, unlike with Apache, there's no need to copy the whole vhost in order
# to have it on HTTP and HTTPS; nginx is smart enough to ignore the ssl_* config
# directives for HTTP clients.

server {
	listen 443 ssl;
	listen 80;
	server_name some-site.com www.some-site.com;
	location / {
		proxy_pass http://127.0.0.1:8080;
	}

	access_log /var/log/nginx/some-site.com_access.log;
	error_log /var/log/nginx/some-site.com_error.log;

	ssl_certificate /etc/letsencrypt/live/some-site.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/some-site.com/privkey.pem;

	include /etc/nginx/includes/proxy;
	include /etc/nginx/includes/letsencrypt;

}
