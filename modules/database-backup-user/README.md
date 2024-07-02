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
| [mysql_grant.backup_global](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/grant) | resource |
| [mysql_grant.backup_history](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/grant) | resource |
| [mysql_grant.backup_progress](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/grant) | resource |
| [mysql_user.backup_user](https://registry.terraform.io/providers/petoju/mysql/3.0.55/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_user"></a> [user](#input\_user) | Configuration for creating a backup user. | <pre>object({<br>    username = optional(string, "mysqlbackup")<br>    password = string<br>    host     = optional(string, "%")<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->