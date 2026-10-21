variable "homelab_public_ip" {
  type        = string
  description = "Public IPv4 of the homelab VPN endpoint. Set TF_VAR_homelab_public_ip locally; CI reads the HOMELAB_PUBLIC_IP secret."
  sensitive   = true
}
