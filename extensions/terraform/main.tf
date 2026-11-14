resource "terraform_data" "deployment_policy" {
  input = {
    environment   = var.environment
    public_access = var.public_access
    allowed_cidrs = var.allowed_cidrs
  }

  lifecycle {
    precondition {
      condition     = !var.public_access || length(var.allowed_cidrs) > 0
      error_message = "Public access requires at least one explicitly allowed CIDR."
    }
  }
}
