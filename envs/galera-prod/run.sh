#!/usr/bin/env bash

set -e

ENV=$(basename "$(pwd)")
PASS_PATH="infra/selfhosted/terraform-state/tf-mariadb-${ENV}"

SECRET="$(pass "${PASS_PATH}")"
STATE_PASSWORD=$(echo "${SECRET}" | head -n1)

TF_ENCRYPTION=$(cat <<EOF
key_provider "pbkdf2" "mykey" {
  passphrase = "${STATE_PASSWORD}"
}
EOF
)
export TF_ENCRYPTION

#terragrunt init
terragrunt apply
