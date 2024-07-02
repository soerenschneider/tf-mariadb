output "credentials" {
  value = [for i in var.users :
    {
      username = i.username,
      password = mysql_user_password.pass[i.username].plaintext_password
    }
  ]
  sensitive = true
}
