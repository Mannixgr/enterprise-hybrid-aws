output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}


output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
output "private_route_table_ids" {
  value = module.network.private_route_table_ids
}

# Site-to-site VPN: values needed to configure strongSwan on the homelab VM

output "vpn_connection_id" {
  value = module.vpn.vpn_connection_id
}

output "tunnel1_address" {
  value = module.vpn.tunnel1_address
}

output "tunnel1_cgw_inside_address" {
  value = module.vpn.tunnel1_cgw_inside_address
}

output "tunnel1_vgw_inside_address" {
  value = module.vpn.tunnel1_vgw_inside_address
}

output "tunnel1_preshared_key" {
  value     = module.vpn.tunnel1_preshared_key
  sensitive = true
}

output "tunnel2_address" {
  value = module.vpn.tunnel2_address
}

output "tunnel2_cgw_inside_address" {
  value = module.vpn.tunnel2_cgw_inside_address
}

output "tunnel2_vgw_inside_address" {
  value = module.vpn.tunnel2_vgw_inside_address
}

output "tunnel2_preshared_key" {
  value     = module.vpn.tunnel2_preshared_key
  sensitive = true
}
