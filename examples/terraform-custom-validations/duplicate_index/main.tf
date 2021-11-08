module "validate_duplicate_index" {
  source = "../../modules/duplicate_index"
  trigger = sha1(file("${path.module}/myJsonFile.json"))
  arguments = "-a validate_duplicate_index -f ${path.module}/myJsonFile.json"
}
