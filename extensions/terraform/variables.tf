variable "environment" {
  type        = string
  description = "Lowercase deployment environment name, using letters, digits, and hyphens."
  default     = "production"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.environment))
    error_message = "The environment must start with a lowercase letter and contain only lowercase letters, digits, or hyphens (maximum 63 characters)."
  }
}

variable "public_access" {
  type        = bool
  description = "Explicitly opt in to public access; an allowlist is required."
  default     = false
  nullable    = false
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "IPv4 or IPv6 CIDR ranges allowed to reach the service; unrestricted /0 ranges are not allowed."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for cidr in var.allowed_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Each allowed CIDR must be a valid IPv4 or IPv6 CIDR."
  }

  validation {
    condition     = alltrue([for cidr in var.allowed_cidrs : try(tonumber(split("/", cidr)[1]) > 0, false)])
    error_message = "Unrestricted /0 CIDR ranges are not allowed."
  }
}
