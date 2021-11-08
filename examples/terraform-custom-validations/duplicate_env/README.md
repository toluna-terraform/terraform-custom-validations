Adding custom validations to Terraform [Terraform module](https://registry.terraform.io/modules/toluna-terraform/validations/custom/latest)

### Description
This module supports adding custom validations not supported by out of the box Terraform validations before applying changes.

## Usage
```hcl
module "validate" {
  source                = "toluna-terraform/terraform-custom-validations/modules/duplicate_env"
  version               = "~>0.0.1" // Change to the required version.
  arguments = "-a validate_duplicate_env -f ${path.module}/some_json_file.json"
}
```

## Toggles
#### Backup, Restore and Initial DB flags:
```yaml
arguments   = command line arguments to pass to the validation script I.E. -a funcation name to run -f some file to validate
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |


## Providers

| Name | Version |
|------|---------|
| <a name="assert"></a> [assert](https://github.com/bwoznicki/terraform-provider-assert) | >= 0.0.1 |


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="validate"></a> [validate](#module\validate) | ../../ |  |

## Resources

No Resources.

## Inputs

No inputs.

## Outputs

No outputs.
