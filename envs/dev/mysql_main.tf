locals {
  env = basename(abspath(path.module))
}

module "db" {
  for_each = { for i, db in var.databases : db.database.name => db }
  source   = "../../modules/database"
  users    = each.value.users
  database = each.value.database
}

module "db_backup_user" {
  count  = var.backup_user == null ? 0 : 1
  source = "../../modules/database-backup-user"
  user   = var.backup_user
}

module "credentials" {
  for_each      = { for i, db in var.databases : db.database.name => db }
  source        = "../../modules/vault"
  path_prefix   = "env/${local.env}/mariadb"
  database_name = each.key
  credentials   = nonsensitive(module.db[each.key].credentials)
  metadata = {
    env = local.env
  }
}
