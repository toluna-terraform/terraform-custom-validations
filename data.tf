data "external" "validate_min_max_index" {
  program = ["/bin/bash","-c","${path.module}/files/validate_envs.sh ${var.arguments}"]
}

data "external" "validate_duplicate_index" {
  program = ["/bin/bash","-c","${path.module}/files/validate_envs.sh ${var.arguments}"]
}

data "external" "validate_duplicate_env" {
  program = ["/bin/bash","-c","${path.module}/files/validate_envs.sh ${var.arguments}"]
}