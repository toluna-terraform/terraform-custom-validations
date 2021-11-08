output "validate_min_max" {
    value = data.external.validate_min_max_index.result
}

output "validate_duplicate" {
    value = data.external.validate_duplicate_index.result
}