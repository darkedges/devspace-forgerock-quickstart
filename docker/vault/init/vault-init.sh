#/bin/sh

root_token=""
if [[ -f "/vault/file/keys.json" ]]
  then
    root_token=$(cat /vault/file/keys.json | jq -r '.root_token')
fi

printf "\n\nVAULT_ADDR=%s\n\n" $VAULT_ADDR
printf "\n\nroot_token=%s\n\n" $root_token

unseal_vault() {
  export VAULT_TOKEN=$root_token
  vault operator unseal -address=${VAULT_ADDR} $(cat /vault/file/keys.json | jq -r '.keys[0]')
  vault login token=$VAULT_TOKEN
}

if [[ -n "$root_token" ]]
  then
      echo "Vault already initialized"
      unseal_vault
  else
      echo "Vault not initialized"
      curl --request POST --data '{"secret_shares": 1, "secret_threshold": 1}' ${VAULT_ADDR}/v1/sys/init > /vault/file/keys.json
      root_token=$(cat /vault/file/keys.json | jq -r '.root_token')
      unseal_vault
fi

printf "\n\nVAULT_TOKEN=%s\n\n" $VAULT_TOKEN