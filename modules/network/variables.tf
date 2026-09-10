variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ (same order as var.azs)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per AZ (same order as var.azs)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway for all private subnets instead of one per AZ. Cheaper, but a single point of failure — fine for dev, reconsider for prod."
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Short name used to prefix/tag resources created by this module"
  type        = string
  default     = "enterprise-hybrid-aws"
}
