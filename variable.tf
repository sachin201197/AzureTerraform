variable "VN1ip" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Virtual network address Space"
}

variable "subnetIP" {
  type        = string
  default     = "10.0.0.50"
  description = "Subnet network address Space"
}
variable "winSize" {
  type    = list(any)
  default = ["Standard_F2", "Standard_DS1"]
}

variable "user" {
  type = map(any)
  default = {
    admin ="sachin"
     a= "b"
  }
}

variable "password" {
  type = map(any)
  default = {
    admin    = "$ac234hin"
    employee = "em12345678"
  }
}