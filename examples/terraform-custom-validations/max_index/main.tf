module "validate_max_index" {
  source = "../../modules/max_env"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_min_max_env -f ${path.module}/myJsonFile.json -m 15"
}