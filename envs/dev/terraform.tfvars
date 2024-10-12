databases = [
  {
    database = {
      name = "keycloak"
    }
    users = [
      {
        username             = "soeren",
        permissions          = ["SELECT", "UPDATE"]
        password             = "hehehaasafasfassasdafd"
        password_store_paths = ["klonk/%s/%s", "plop/%s/%s"]
      }
    ]
  }
]

backup_user = {
  password = "notverysecureatallnotverysecureatall"
}
