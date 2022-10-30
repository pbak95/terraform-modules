variable "namespace" {
  type = string
}

variable "annotations" {
  type = map(string)
  default = {}
}

variable "labels" {
  type = map(string)
  default = {}
}
