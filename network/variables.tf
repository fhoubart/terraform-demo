variable "subnet_scope" {
    type = string
    default = "10.0.0.0/24"
}
variable "vpc_scope" {
    type = string
    default = "10.0.0.0/16"
}
variable "name" {
    type = string
    default = "web"
}