module "validate_duplicate_env" {
  source = "../../modules/duplicate_env"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_duplicate_env -f ${path.module}/myJsonFile.json"
}