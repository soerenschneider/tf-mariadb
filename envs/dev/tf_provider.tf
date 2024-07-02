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
  endpoint = "localhost:3306"
  username = "root"
  password = "mypass"
}

provider "vault" {
  address = "http://localhost:8200"
  token   = "test"
}
