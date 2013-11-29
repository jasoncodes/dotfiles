# initialise rbenv
if which rbenv &> /dev/null; then
  eval "$(rbenv init - --no-rehash)"
fi

# use our own SSL root certificate if present
if [[ -z "$SSL_CERT_FILE" ]] && [[ -f "/usr/local/etc/openssl/cert.pem" ]]; then
  export SSL_CERT_FILE="/usr/local/etc/openssl/cert.pem"
fi
if [[ -z "$SSL_CERT_FILE" ]] && [[ -f "/usr/local/etc/openssl/certs/cert.pem" ]]; then
  export SSL_CERT_FILE="/usr/local/etc/openssl/certs/cert.pem"
fi
