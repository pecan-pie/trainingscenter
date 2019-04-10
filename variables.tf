variable "do_token" {
  type = "string"
}

/*
    domain wich is used for the cluster
*/
variable "domain" {
  type    = "string"
  default = "example.com"
}

/*
    domain wich is used for the cluster
*/
variable "acme_mail" {
  type    = "string"
  default = "info@example.com"
}