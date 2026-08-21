variable "transit_gateway_id" {
  description = "ID of the central Transit Gateway"
  type        = string
}

variable "spoke_vpc_id" {
  description = "ID of the Spoke VPC"
  type        = string
}

variable "transit_subnet_ids" {
  description = "List of subnet IDs for the TGW attachment"
  type        = list(string)
}

variable "spoke_tgw_route_table_id" {
  description = "ID of the TGW Route Table for the spoke"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "common_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}