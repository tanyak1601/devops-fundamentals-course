#!/usr/bin/env bash

SERVER_HOST_DIR=$(pwd)/nestjs-rest-api
CLIENT_HOST_DIR=$(pwd)/shop-react-redux-cloudfront

SERVER_REMOTE_DIR=/var/app/nestjs-rest-api
CLIENT_REMOTE_DIR=var/www/shop-react-redux-cloudfront

NGINX_CONFIG_PATH=usr/local/etc/nginx/nginx.conf

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh ubuntu-sshuser "[ ! -d $1 ]"; then
    echo "Creating: $1"
	ssh -t ubuntu-sshuser "sudo bash -c 'mkdir -p $1 && chown -R sshuser: $1'"
  else
    echo "Clearing: $1"
    ssh ubuntu-sshuser "sudo -S rm -r $1/*"
  fi
}

check_remote_dir_exists $SERVER_REMOTE_DIR
check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building and copying server files - START <---"
echo $SERVER_HOST_DIR
cd $SERVER_HOST_DIR && npm run build
scp -Cr dist/ package.json ubuntu-sshuser:$SERVER_REMOTE_DIR
echo "---> Building and transfering server - COMPLETE <---"

echo "---> Building and transfering client files, cert and ngingx config - START <---"
echo $CLIENT_HOST_DIR
cd $CLIENT_HOST_DIR && npm run build && cd ../
scp -Cr $CLIENT_HOST_DIR/dist/* CLIENT_HOST_DIR/my-cert.crt CLIENT_HOST_DIR/my-cert.key $NGINX_CONFIG_PATH ubuntu-sshuser:$CLIENT_REMOTE_DIR
echo "---> Building and transfering - COMPLETE <---"