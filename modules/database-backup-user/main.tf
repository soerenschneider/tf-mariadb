resource "mysql_user" "backup_user" {
  user               = var.user.username
  plaintext_password = var.user.password
  host               = var.user.host
}

resource "mysql_grant" "backup_global" {
  user       = mysql_user.backup_user.user
  host       = mysql_user.backup_user.host
  database   = "*"
  table      = ""
  privileges = ["SELECT", "RELOAD", "PROCESS", "SUPER", "SHOW DATABASES", "LOCK TABLES", "REPLICATION CLIENT"]
}

resource "mysql_grant" "backup_progress" {
  user       = mysql_user.backup_user.user
  host       = mysql_user.backup_user.host
  database   = "mysql"
  table      = "backup_progress"
  privileges = ["CREATE", "INSERT", "DROP", "UPDATE"]
}

resource "mysql_grant" "backup_history" {
  user       = mysql_user.backup_user.user
  host       = mysql_user.backup_user.host
  database   = "mysql"
  table      = "backup_history"
  privileges = ["CREATE", "INSERT", "DROP", "UPDATE", "SELECT", "ALTER"]
}
