variable "database_name" {
  type = string

  validation {
    condition     = length(var.database_name) >= 3 && length(var.database_name) <= 64 && can(regex("^[_a-zA-Z0-9]+$", var.database_name))
    error_message = "The database name must be between 3 and 64 characters long and contain only letters, numbers, and underscores."
  }

  description = "Name of the database the users belong to."
}

variable "credentials" {
  type = object({
    username = string,
    password = string
  })

  description = "Credentials for the appropriate database."
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

variable "password_store_paths" {
  type        = list(string)
  description = "Paths to write the secret to."

  validation {
    condition = alltrue([
      for path in var.password_store_paths : length(path) >= 5
    ])
    error_message = "Each path in password_store_paths must be at least 5 characters long."
  }

  validation {
    condition = alltrue([
      for path in var.password_store_paths :
      !startswith(path, "/") && !endswith(path, "/")
    ])
    error_message = "Each path in password_store_paths must not start or end with a slash ('/')."
  }

  validation {
    condition = alltrue([
      for path in var.password_store_paths : can(regex("%s", path))
    ])
    error_message = "Each path in password_store_paths must contain the substring '%s'."
  }
}

variable "metadata" {
  type    = map(any)
  default = null

  description = "Optional metadata to attach to the secret data."
}
