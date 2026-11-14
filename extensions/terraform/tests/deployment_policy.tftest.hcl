run "private_by_default" {
  command = plan

  assert {
    condition     = !terraform_data.deployment_policy.input.public_access && length(terraform_data.deployment_policy.input.allowed_cidrs) == 0
    error_message = "The default policy must not enable public access or allow any CIDRs."
  }
}

run "explicit_public_access_with_allowlist" {
  command = plan

  variables {
    public_access = true
    allowed_cidrs = ["203.0.113.0/24", "2001:db8::/32"]
  }

  assert {
    condition     = terraform_data.deployment_policy.input.public_access && length(terraform_data.deployment_policy.input.allowed_cidrs) == 2
    error_message = "Explicit public access must preserve its allowed CIDRs."
  }
}

run "public_access_requires_allowlist" {
  command = plan

  variables {
    public_access = true
  }

  expect_failures = [terraform_data.deployment_policy]
}

run "reject_unrestricted_ipv4" {
  command = plan

  variables {
    public_access = true
    allowed_cidrs = ["0.0.0.0/0"]
  }

  expect_failures = [var.allowed_cidrs]
}

run "reject_unrestricted_ipv6" {
  command = plan

  variables {
    public_access = true
    allowed_cidrs = ["::/0"]
  }

  expect_failures = [var.allowed_cidrs]
}

run "reject_invalid_cidr" {
  command = plan

  variables {
    allowed_cidrs = ["not-a-cidr"]
  }

  expect_failures = [var.allowed_cidrs]
}

run "reject_invalid_environment" {
  command = plan

  variables {
    environment = "Production!"
  }

  expect_failures = [var.environment]
}
