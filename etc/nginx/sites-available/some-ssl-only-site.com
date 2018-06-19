# This is a basic site available over HTTPS only, proxied back to port 8080 on 
# the localhost.
#
# Because this server has no 'listen 80' directive, non HTTPS requests for the
# site (to http://some-ssl-only-site.com) will hit the default server, which 
# will return a redirect to https.

server {
	listen 443 ssl;
	server_name some-ssl-only-site.com www.some-ssl-only-site.com;
	location / {
		proxy_pass http://127.0.0.1:8080;
	}

	access_log /var/log/nginx/some-site.com_access.log;
	error_log /var/log/nginx/some-site.com_error.log;

	ssl_certificate /etc/letsencrypt/live/some-site.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/some-site.com/privkey.pem;

	include /etc/nginx/snippets/proxy;
	include /etc/nginx/snippets/letsencrypt;

}
