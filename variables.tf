/*
  Access Token which is for accessing DigitalOcean APIs.
*/
variable "do_token" {
  type = string
}

/*
    Domain wich is used for the cluster.
*/
variable "domain" {
  type = string
}

/*
    Email address which is used for DNS challenges to obtain SSL certificates.
*/
variable "acme_mail" {
  type = string
}

