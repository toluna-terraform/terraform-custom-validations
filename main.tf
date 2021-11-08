# resource "null_resource" "validate_envs" {
#  triggers = {
#     trigger = var.trigger
#   }
#   provisioner "local-exec" {
#     command = "${path.module}/files/validate_envs.sh ${var.arguments}"
#     on_failure  = fail
#   }

# }