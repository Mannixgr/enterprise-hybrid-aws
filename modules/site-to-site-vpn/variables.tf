variable "project_name" {
  type        = string
  description = "Project name used for naming and tagging resources"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to attach the virtual private gateway to"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Route table IDs that receive VGW route propagation (homelab routes)"
}

variable "homelab_public_ip" {
  type        = string
  description = "Public IPv4 address of the on-prem VPN endpoint (customer gateway). No default: supply via TF_VAR_homelab_public_ip."

  validation {
    condition     = can(cidrhost("${var.homelab_public_ip}/32", 0))
    error_message = "homelab_public_ip must be a single valid IPv4 address, e.g. 198.51.100.42."
  }
}

variable "homelab_cidrs" {
  type        = list(string)
  description = "On-prem CIDR blocks reachable through the VPN (static routes)"
  default     = ["192.168.1.0/24"]
}

variable "tunnel1_inside_cidr" {
  type        = string
  description = "Inside /30 for tunnel 1, within 169.254.0.0/16 (e.g. 169.254.10.0/30)"

  validation {
    condition = (
      startswith(var.tunnel1_inside_cidr, "169.254.") &&
      endswith(var.tunnel1_inside_cidr, "/30") &&
      !contains([
        "169.254.0.0/30", "169.254.1.0/30", "169.254.2.0/30",
        "169.254.3.0/30", "169.254.4.0/30", "169.254.5.0/30",
        "169.254.169.252/30",
      ], var.tunnel1_inside_cidr)
    )
    error_message = "tunnel1_inside_cidr must be a non-reserved /30 inside 169.254.0.0/16."
  }
}
variable "tunnel2_inside_cidr" {
  type        = string
  description = "Inside /30 for tunnel 2, within 169.254.0.0/16 (e.g. 169.254.10.0/30)"

  validation {
    condition = (
      startswith(var.tunnel2_inside_cidr, "169.254.") &&
      endswith(var.tunnel2_inside_cidr, "/30") &&
      !contains([
        "169.254.0.0/30", "169.254.1.0/30", "169.254.2.0/30",
        "169.254.3.0/30", "169.254.4.0/30", "169.254.5.0/30",
        "169.254.169.252/30",
      ], var.tunnel2_inside_cidr)
    )
    error_message = "tunnel2_inside_cidr must be a non-reserved /30 inside 169.254.0.0/16."
  }
}

