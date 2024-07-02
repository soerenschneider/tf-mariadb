variable "database_name" {
  type = string

  validation {
    condition     = length(var.database_name) >= 3 && length(var.database_name) <= 64 && can(regex("^[_a-zA-Z0-9]+$", var.database_name))
    error_message = "The database name must be between 3 and 64 characters long and contain only letters, numbers, and underscores."
  }

  description = "Name of the database the users belong to."
}

variable "credentials" {
  type = list(
    object({
      username = string,
      password = string
  }))

  description = "List of credentials for the appropriate database."
}

variable "vault_kv2_mount" {
  type    = string
  default = "secret"

  validation {
    condition     = !endswith(var.vault_kv2_mount, "/") && length(var.vault_kv2_mount) > 3
    error_message = "vault_kv2_mount should not end with a slash."
  }

  description = "Path where KV2 secret engine is mounted in HashiCorp Vault."
}

variable "path_prefix" {
  type    = string
  default = "mariadb"

  validation {
    condition     = length(var.path_prefix) >= 3
    error_message = "path_prefix must be more than 2 characters."
  }

  validation {
    condition     = !(startswith(var.path_prefix, "/") || endswith(var.path_prefix, "/"))
    error_message = "Invalid path_prefix: must not start or end with a slash ('/')."
  }

  description = "Prefix added to the path where secrets are stored."
}

variable "metadata" {
  type    = map(any)
  default = null

  description = "Optional metadata to attach to the secret data."
}
