locals {
  default_host        = "%"
  default_permissions = ["ALL PRIVILEGES"]
}

resource "mysql_database" "db" {
  name                  = var.database.name
  default_character_set = var.database.default_character_set
  default_collation     = var.database.default_collation
}

resource "mysql_user" "user" {
  for_each = { for user in var.users : user.username => user }
  user     = each.value.username
  host     = coalesce(each.value.host, local.default_host)
}

resource "mysql_user_password" "pass" {
  for_each           = { for user in var.users : user.username => user }
  host               = mysql_user.user[each.key].host
  user               = mysql_user.user[each.key].user
  plaintext_password = each.value.password
}

resource "mysql_grant" "grant" {
  for_each   = { for user in var.users : user.username => user }
  user       = mysql_user.user[each.key].user
  host       = mysql_user.user[each.key].host
  database   = mysql_database.db.name
  privileges = toset(coalesce(each.value.permissions, local.default_permissions))
}
