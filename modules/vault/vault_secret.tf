resource "vault_kv_secret_v2" "tokens" {
  for_each            = { for path in var.password_store_paths : path => path }
  mount               = var.vault_kv2_mount
  name                = format(each.value, var.database_name, var.credentials.username)
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = var.credentials.password,
    }
  )
  custom_metadata {
    max_versions = 1
    data         = merge(local.metadata_default, var.metadata)
  }
}

locals {
  metadata_default = {
    repo       = "https://github.com/soerenschneider/tf-mariadb"
    managed-by = "terraform"
  }
}
