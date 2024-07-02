#!/usr/bin/env bash

set -eu

ENV="${1:-prod}"

echo "Running tofu apply for env ${ENV}"

MARIADB_SECRET_PATH="infra/selfhosted/dbs/mariadb-${ENV}"
TF_SECRET_PATH="infra/selfhosted/terraform-state/tf-mariadb-${ENV}"

#echo "Reading mariadb credentials..."
#OUTPUT=$(pass "${MARIADB_SECRET_PATH}")
#MYSQL_USERNAME=$(echo "${OUTPUT}" | grep ^MYSQL_USER= | cut -d'=' -f2)
#export MYSQL_USERNAME
#
#MYSQL_PASSWORD=$(echo "${OUTPUT}" | grep ^MYSQL_PASSWORD= | cut -d'=' -f2)
#export MYSQL_PASSWORD

echo "Reading opentofu state encryption key..."
OUTPUT=$(pass "${TF_SECRET_PATH}")
_TF_KEY=$(echo "${OUTPUT}" | head -n1)
export _TF_KEY

TF_ENCRYPTION=$(cat <<EOF
key_provider "pbkdf2" "mykey" {
  passphrase = "${_TF_KEY}"
}
EOF
)
export TF_ENCRYPTION

terragrunt --terragrunt-working-dir="envs/${ENV}" apply
