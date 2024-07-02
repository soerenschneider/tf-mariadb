variable "databases" {
  type = list(
    object({
      database = object({
        name = string
      }),
      users = list(
        object({
          username    = string,
          password    = string
          permissions = optional(set(string)),
          host        = optional(string)
      }))
  }))

  description = "A list of databases and associated users configurations."
}

variable "backup_user" {
  type = object({
    username = optional(string)
    password = string
    host     = optional(string)
  })
  default = null

  description = "Configuration for creating a backup user."
}
