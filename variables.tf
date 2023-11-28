
variable "regions" {
  type    = string
  default = "ap-south-1"
  description = "AWS region"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "ami" {
  type    = string
  default = "ami-0287a05f0ef0e9d9a"
}

