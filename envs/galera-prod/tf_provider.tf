terraform {
  required_version = ">= 1.6.0"
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.55"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "4.2.0"
    }
  }

  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.mykey
    }

    state {
      enforced = true
      method   = method.aes_gcm.default
    }
    plan {
      method   = method.aes_gcm.default
      enforced = true
    }
  }
}

provider "mysql" {
  endpoint = "dbs.pt.soeren.cloud:3306"
  username = var.mariadb_username
  password = var.mariadb_password
  tls      = true
}

provider "vault" {
  address = "https://vault.ha.soeren.cloud"
}
