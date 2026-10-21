output "vpn_gateway_id" {
  description = "ID of the virtual private gateway"
  value       = aws_vpn_gateway.this.id
}

output "vpn_connection_id" {
  description = "ID of the site-to-site VPN connection"
  value       = aws_vpn_connection.this.id
}

# Tunnel 1

output "tunnel1_address" {
  description = "AWS public endpoint for tunnel 1 (strongSwan remote_addrs)"
  value       = aws_vpn_connection.this.tunnel1_address
}

output "tunnel1_cgw_inside_address" {
  description = "Homelab side of tunnel 1 inside /30 (vti1 local address)"
  value       = aws_vpn_connection.this.tunnel1_cgw_inside_address
}

output "tunnel1_vgw_inside_address" {
  description = "AWS side of tunnel 1 inside /30 (vti1 peer, ping target)"
  value       = aws_vpn_connection.this.tunnel1_vgw_inside_address
}

output "tunnel1_preshared_key" {
  description = "Pre-shared key for tunnel 1 (strongSwan secrets). Stored in state."
  value       = aws_vpn_connection.this.tunnel1_preshared_key
  sensitive   = true
}

# Tunnel 2

output "tunnel2_address" {
  description = "AWS public endpoint for tunnel 2 (strongSwan remote_addrs)"
  value       = aws_vpn_connection.this.tunnel2_address
}

output "tunnel2_cgw_inside_address" {
  description = "Homelab side of tunnel 2 inside /30 (vti2 local address)"
  value       = aws_vpn_connection.this.tunnel2_cgw_inside_address
}

output "tunnel2_vgw_inside_address" {
  description = "AWS side of tunnel 2 inside /30 (vti2 peer, ping target)"
  value       = aws_vpn_connection.this.tunnel2_vgw_inside_address
}

output "tunnel2_preshared_key" {
  description = "Pre-shared key for tunnel 2 (strongSwan secrets). Stored in state."
  value       = aws_vpn_connection.this.tunnel2_preshared_key
  sensitive   = true
}
