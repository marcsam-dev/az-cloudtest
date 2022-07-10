variable "elite_general_network" {
  type    = string
  default = "elite_general_network"
}

variable "location" {
  type    = string
  default = "EASTUS2"
}

variable "elite_devnsg" {
  type    = string
  default = "elite_devnsg"
}

variable "elitedev_vnet" {
  type    = string
  default = "elitedev_vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.0.4", "10.0.0.5"]
}

variable "elite_rtb" {
  type    = string
  default = "elite_rtb"
}

variable "database_subnet" {
  type    = string
  default = "database_subnet"
}

variable "application_subnet" {
  type    = string
  default = "application_subnet"
}

variable "address_prefixes_database" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "address_prefixes_application" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "source_address_prefix" {
  type    = string
  default = "197.210.54.37/32"
}

variable "destination_address_prefix" {
  type    = string
  default = "VirtualNetwork"
}
