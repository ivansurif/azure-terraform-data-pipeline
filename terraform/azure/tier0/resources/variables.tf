
variable "location" {
  default = "eastus"
}


variable "server" {
  default = "skfcenitdevtemp5.azurecr.io"
}

variable "SAMPLE_SECRET" {
  type        = string
  description = "Sample env variable whose value is obtained from a GH Secret."
}



