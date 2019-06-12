#!/usr/bin/env bash

echo -en '\n'
echo -n 'Generating JWT OpenSSL Keys...'
echo -en '\n'

mkdir -p config/keys
openssl genrsa -out config/keys/private.pem -aes256 4096
openssl rsa -pubout -in config/keys/private.pem -out config/keys/public.pem

chmod g+r,o+r config/keys/private.pem
chmod g+r,g+w,o+r config/keys/public.pem