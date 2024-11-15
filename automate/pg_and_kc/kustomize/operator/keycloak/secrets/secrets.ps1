

openssl req -subj '/CN=test.keycloak.org/O=Test Keycloak./C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem

kubectl create secret tls keycloak-tls-secret --cert certificate.pem --key key.pem