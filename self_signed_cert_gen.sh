#!/usr/bin/env bash
# self_signed_cert_gen.sh
#
# Instructions:
# ./self_signed_cert_gen.sh <domain>
#

domain=$1

openssl req -new -x509 -extensions v3_req -newkey rsa:8192 -nodes -days 3650 \
  -subj "/O=$domain/CN=*.$domain/subjectAltName=DNS:*.$domain/" \
  -out self_signed.crt -keyout self_signed.key
openssl dhparam -out dhparm.pem 2048
chmod 600 self_signed.key
