terraform {
  required_version = ">= 1.6.0"
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.55"
    }
  }
}
