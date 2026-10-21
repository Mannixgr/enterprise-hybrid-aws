resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-vgw"
  }
}

resource "aws_customer_gateway" "homelab" {
  bgp_asn    = 65000
  ip_address = var.homelab_public_ip
  type       = "ipsec.1"

  tags = {
    Name = "${var.project_name}-cgw"
  }
}

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.homelab.id
  type                = "ipsec.1"
  static_routes_only  = true
  tunnel1_inside_cidr = var.tunnel1_inside_cidr
  tunnel2_inside_cidr = var.tunnel2_inside_cidr

  tags = {
    Name = "${var.project_name}-vpn"
  }
}

resource "aws_vpn_connection_route" "homelab" {
  for_each               = toset(var.homelab_cidrs)
  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.this.id
}

resource "aws_vpn_gateway_route_propagation" "private" {
  for_each       = { for i, id in var.private_route_table_ids : i => id }
  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = each.value
}

