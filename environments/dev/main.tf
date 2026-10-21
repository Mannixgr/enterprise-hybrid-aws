module "network" {
  source = "../../modules/network"

  project_name = "enterprise-hybrid-aws-dev"

  # 10.20.0.0/16 avoids overlap with the Rogers gateway network (10.0.0.0/24)
  # and the homelab LAN (192.168.1.0/24), which matters for the site-to-site VPN.
  vpc_cidr             = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.0.0/24", "10.20.1.0/24"]
  private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]

  enable_dashboard = true

  # Other module defaults (2 AZs, single NAT Gateway) are fine for dev.
  # Override here if this environment ever needs something different.
}

module "vpn" {
  source = "../../modules/site-to-site-vpn"

  project_name            = "enterprise-hybrid-aws-dev"
  vpc_id                  = module.network.vpc_id
  private_route_table_ids = module.network.private_route_table_ids
  homelab_public_ip       = var.homelab_public_ip

  tunnel1_inside_cidr = "169.254.10.0/30"
  tunnel2_inside_cidr = "169.254.11.0/30"
}
