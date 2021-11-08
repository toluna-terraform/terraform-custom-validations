terraform {
  required_providers {
    #add assertions to validate json
    assert = {
      source  = "bwoznicki/assert" 
    }
  }
}

data "external" "validate_duplicate_index" {
  program = ["/bin/bash","-c","${path.module}/../../files/validate_envs.sh ${var.arguments}"]
}

data "assert_test" "max_index" {
    test = "${data.external.validate_duplicate_index.result.valid}" == "true" // must return TRUE or FALSE
    throw = try("${data.external.validate_duplicate_index.result.message}","success") // must be of type string
} 