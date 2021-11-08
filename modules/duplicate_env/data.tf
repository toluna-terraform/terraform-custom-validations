terraform {
  required_providers {
    #add assertions to validate json
    assert = {
      source  = "bwoznicki/assert" 
    }
  }
}

data "external" "validate_duplicate_env" {
  program = ["/bin/bash","-c","${path.module}/../../files/validate_envs.sh ${var.arguments}"]
}

data "assert_test" "validate_duplicate_env" {
    test = "${data.external.validate_duplicate_env.result.valid}" == "true" // must return TRUE or FALSE
    throw = try("${data.external.validate_duplicate_env.result.message}","success") // must be of type string
} 


