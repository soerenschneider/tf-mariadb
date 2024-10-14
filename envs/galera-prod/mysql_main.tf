locals {
  instance                     = basename(abspath(path.module))
  password_store_paths_default = ["env/${local.instance}/mariadb/%s/%s"]
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

locals {
  combined_outputs = flatten([
    for key, db in module.db : [
      for cred in db.credentials : {
        db_key               = key
        username             = cred.username
        password             = cred.password
        password_store_paths = cred.password_store_paths
      }
    ]
  ])
}

module "credentials" {
  for_each             = { for idx, item in nonsensitive(local.combined_outputs) : item.db_key => item }
  source               = "../../modules/vault"
  database_name        = each.key
  password_store_paths = coalescelist(each.value.password_store_paths, var.password_store_paths, local.password_store_paths_default)
  credentials          = { username = each.value.username, password = each.value.password }
  metadata = {
    env = local.instance
  }
}
