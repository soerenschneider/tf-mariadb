variable "database" {
  type = object({
    name                  = string
    default_character_set = optional(string)
    default_collation     = optional(string)
  })

  validation {
    condition     = length(var.database.name) >= 3 && length(var.database.name) <= 64 && can(regex("^[_a-zA-Z0-9]+$", var.database.name))
    error_message = "The database name must be between 3 and 64 characters long and contain only letters, numbers, and underscores."
  }

  description = "Configuration for the database."
}

variable "users" {
  type = list(object({
    username       = string,
    password       = optional(string),
    permissions    = optional(list(string)),
    host           = optional(string),
    vault_prefixes = optional(list(string))
  }))

  validation {
    condition     = alltrue(flatten([for x in var.users : [for permission in coalesce(x.permissions, []) : contains(["ALL PRIVILEGES", "ALTER", "ALTER ROUTINE", "CREATE", "CREATE ROLE", "CREATE ROUTINE", "CREATE TABLESPACE", "CREATE TEMPORARY TABLES", "CREATE USER", "CREATE VIEW", "DELETE", "DROP", "DROP ROLE", "EVENT", "EXECUTE", "FILE", "GRANT OPTION", "INDEX", "INSERT", "LOCK TABLES", "PROCESS", "PROXY", "REFERENCES", "RELOAD", "REPLICATION CLIENT", "REPLICATION SLAVE", "SELECT", "SHOW DATABASES", "SHOW VIEW", "SHUTDOWN", "SUPER", "TRIGGER", "UPDATE", "USAGE"], permission)]]))
    error_message = "Invalid permissions provided."
  }

  validation {
    condition     = alltrue([for x in var.users : x.password == null ? true : length(x.password) >= 20])
    error_message = "Password must be at least 16 characters long if it is not null."
  }

  description = "List of users with their permissions and configurations."
}

