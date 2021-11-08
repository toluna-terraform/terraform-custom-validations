module "validate_max_index" {
  source = "../../modules/max_env"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_min_max_env -f ${path.module}/myJsonFile.json -m 15"
}

module "validate_duplicate_index" {
  source = "../../modules/duplicate_index"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_duplicate_index -f ${path.module}/myJsonFile.json"
}

module "validate_duplicate_env" {
  source = "../../modules/duplicate_env"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_duplicate_env -f ${path.module}/myJsonFile.json"
}

