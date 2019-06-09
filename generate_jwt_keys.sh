#!/usr/bin/env bash

echo -en '\n'
echo -n 'Generating JWT OpenSSL Keys...'
echo -en '\n'

mkdir -p config/keys
openssl genrsa -out config/keys/private.pem -aes256 4096
openssl rsa -in config/keys/private.pem -out config/keys/public.pem