variable "name" {
  description = "name of service"
  type = "string"
  default = "confluence"
}

variable "network-ip" {
  description = "ip range of internal subnet"
  type = "string"
  default = "10.126.0.0/20"
}
