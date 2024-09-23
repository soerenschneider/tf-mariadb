<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_mysql"></a> [mysql](#requirement\_mysql) | 3.0.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mysql"></a> [mysql](#provider\_mysql) | 3.0.55 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mysql_database.db](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/database) | resource |
| [mysql_grant.grant](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/grant) | resource |
| [mysql_user.user](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/user) | resource |
| [mysql_user_password.pass](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/user_password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database"></a> [database](#input\_database) | Configuration for the database. | <pre>object({<br/>    name                  = string<br/>    default_character_set = optional(string)<br/>    default_collation     = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | List of users with their permissions and configurations. | <pre>list(object({<br/>    username       = string,<br/>    password       = optional(string),<br/>    permissions    = optional(list(string)),<br/>    host           = optional(string),<br/>    vault_prefixes = optional(list(string))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_credentials"></a> [credentials](#output\_credentials) | n/a |
<!-- END_TF_DOCS -->