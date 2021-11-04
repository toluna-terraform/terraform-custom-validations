Adding custom validations to Terraform [Terraform module](https://registry.terraform.io/modules/toluna-terraform/validations/custom/latest)

### Description
This module supports adding custom validations not supported by out of the box Terraform validations before applying changes.

## Usage
```hcl
module "validate" {
  source                = "toluna-terraform/terraform-aws-mongodb"
  version               = "~>0.0.1" // Change to the required version.
  trigger = sha1(file("${path.module}/some_json_file.json"))
  arguments = "-a validate_duplicate_env -f ${path.module}/some_json_file.json"
}
```

## Toggles
#### Backup, Restore and Initial DB flags:
```yaml
trigger     = place here what would trigger the validation I.E. to trigger validation on changes to a file you can place sha1(file("some file"))
arguments   = command line arguments to pass to the validation script I.E. -a funcation name to run -f some file to validate
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |


## Providers

No providers


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="validate"></a> [validate](#module\validate) | ../../ |  |

## Resources

| Name | Type |
|------|------|
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |


## Inputs

No inputs.

## Outputs

No outputs.
