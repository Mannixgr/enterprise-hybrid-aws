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
