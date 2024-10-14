variable "databases" {
  type = list(
    object({
      database = object({
        name = string
      }),
      users = list(
        object({
          username             = string,
          password             = string
          permissions          = optional(set(string)),
          host                 = optional(string)
          password_store_paths = optional(list(string))
      }))
  }))

  sensitive   = true
  description = "A list of databases and associated users configurations."
}

variable "backup_user" {
  type = object({
    username             = optional(string)
    password             = string
    host                 = optional(string)
    password_store_paths = optional(list(string))
  })
  default = null

  description = "Configuration for creating a backup user."
}

variable "password_store_paths" {
  type        = list(string)
  default     = []
  description = "Password storage path"
}
