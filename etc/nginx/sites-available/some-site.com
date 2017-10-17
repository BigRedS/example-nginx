server {
	listen 443 ssl;
	listen 80;
	server_name some-site.com www.manchestercarersnetwork.org.uk;
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
