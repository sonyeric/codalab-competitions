#!/bin/sh

echo | env

echo "@@@@@@@@@@@@@"
echo "${SSL_CERTIFICATE}"
echo $(-z "$SSL_CERTIFICATE")
echo "@@@@@@@@@@@@@"

echo "GENERATING NGINX CONF TEMPLATE..."

# NOTE: We set dollar here to escape $var's in nginxconf, instead we write
# ${DOLLAR}var to escape it.
export DOLLAR='$'

# Swap configs based on SSL
if [[ $SSL_CERTIFICATE ]]
then
    echo "Using SSL certificate '${SSL_CERTIFICATE}' and allowing hosts '${SSL_ALLOWED_HOSTS}'"
    envsubst < app/nginx/confs/ssl.conf > /etc/nginx/conf.d/default.conf
else
    echo "No SSL certificate env var (SSL_CERTIFICATE) found"
    envsubst < app/nginx/confs/nginx.conf > /etc/nginx/conf.d/default.conf
fi

echo "nginx/default.conf:"
echo | cat /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
