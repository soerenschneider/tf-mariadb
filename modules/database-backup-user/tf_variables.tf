variable "user" {
  type = object({
    username = optional(string, "mysqlbackup")
    password = string
    host     = optional(string, "%")
  })

  validation {
    condition     = length(var.user.username) >= 5
    error_message = "username for backup user must be at least 5 characters."
  }

  validation {
    condition     = length(var.user.password) >= 20
    error_message = "password for backup user must be at least 20 characters."
  }

  validation {
    condition     = var.user.host == "%" || length(var.user.host) >= 8
    error_message = "host of backup user must be either '%' or a valid ip address/netmask"
  }

  description = "Configuration for creating a backup user."
}
