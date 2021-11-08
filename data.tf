data "external" "validate" {
  program = ["/bin/bash","-c","${path.module}/files/validate_envs.sh ${var.arguments}"]
}

data "assert_test" "validate" {
    test = "${data.external.validate.result.valid}" == "true" // must return TRUE or FALSE
    throw = try("${data.external.validate.result.message}","success") // must be of type string
} 