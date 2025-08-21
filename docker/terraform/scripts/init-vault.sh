#/bin/sh
export VAULT_TOKEN=$(cat /vault/file/keys.json | jq -r '.root_token')

terraform init
terraform plan
terraform apply --auto-approve

# Install the HashiCorp vault Root and Intermediate CA
NAMESPACE=${NAMESPACE:-dfq}
VAULT_ADDR=${VAULT_ADDR:-http://vault:8201}
curl -o /mnt/secrets/${NAMESPACE}_idam_intermediate.pem ${VAULT_ADDR}/v1/${NAMESPACE}_idam_intermediate/ca/pem
curl -o /mnt/secrets/${NAMESPACE}_idam_root.pem ${VAULT_ADDR}/v1/${NAMESPACE}_idam_root/ca/pem

for f in /mnt/secrets/*.pem; do (cat "${f}"; echo) >> /mnt/secrets/fram/cacerts.pem; done
