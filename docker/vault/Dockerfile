FROM hashicorp/vault:1.16.2

# Install requirements via Artifactory alpine mirror
RUN apk add --no-cache curl jq

COPY config/ /vault/config/
COPY init/vault-init.sh /vault-init.sh