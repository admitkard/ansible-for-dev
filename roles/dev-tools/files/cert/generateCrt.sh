#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a domain"
  exit 1
fi

DOMAIN=$1
CA_NAME=myCA

mkdir $DOMAIN

openssl genrsa -out $DOMAIN/$DOMAIN.key 2048
openssl req -new -key $DOMAIN/$DOMAIN.key -out $DOMAIN/$DOMAIN.csr -subj "/C=IN/ST=UTTAR PRADESH/L=NOIDA/O=PINEYARDS SOLUTIONS PVT LTD/OU=ADMITKARD/MAIL=PIYUSH.KUMAR@ADMITKARD.COM/CN=*.$DOMAIN"

cat > $DOMAIN/$DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = admitkard.xyz
DNS.2 = *.admitkard.xyz
DNS.3 = $DOMAIN
EOF

openssl x509 -req -in $DOMAIN/$DOMAIN.csr -CA $CA_NAME.pem -CAkey $CA_NAME.key -CAcreateserial \
-out $DOMAIN/$DOMAIN.crt -days 3650 -sha256 -extfile $DOMAIN/$DOMAIN.ext 
