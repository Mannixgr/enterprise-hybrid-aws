module "network" {
  source = "../../modules/network"

  project_name = "enterprise-hybrid-aws-dev"

  # Defaults from the module (10.0.0.0/16, 2 AZs, single NAT Gateway) are fine for dev.
  # Override here if this environment ever needs something different.
}
