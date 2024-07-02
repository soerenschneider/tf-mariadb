databases = [
  {
    database = {
      name = "keycloak"
    }
    users = [
      {
        username    = "soeren",
        permissions = ["SELECT", "UPDATE"]
        password    = "hehehaasafasfassasdafd"
      }
    ]
  }
]

backup_user = {
  password = "notverysecureatallnotverysecureatall"
}
