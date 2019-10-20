#!/usr/bin/env bash

## Source: https://serversforhackers.com/self-signed-ssl-certificates

# Set the wildcarded domain
# we want to use
DOMAIN="*.test"

# A blank passphrase
PASSPHRASE=""

# Generate our Private Key, CSR and Certificate
# openssl genrsa -out "$SSL_DIR/server.key" 2048
# openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/server.key" -out "$SSL_DIR/server.csr" -passin pass:$PASSPHRASE
# openssl x509 -req -days 3650 -in "$SSL_DIR/server.csr" -signkey "$SSL_DIR/server.key" -out "$SSL_DIR/server.crt"
openssl req -x509 -nodes -days 3650 -subj "/C=NL/ST=Utrecht/L=Utrecht/O=BrightAlley/CN=$DOMAIN" -newkey rsa:2048 -keyout /usr/local/apache2/conf/server.key -out /usr/local/apache2/conf/server.crt
