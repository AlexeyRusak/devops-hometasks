variable "number_replicas" {}
variable "image_id" {}
variable "app_name" {}
variable "labels_name" {}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
    typesrv  = string
    
  }))
  default = [
    {
      internal = 80
      external = 30909
      protocol = "TCP"
      typesrv  = "NodePort"
    }
  ]
}

variable "token" {} # token define as system env TF_VAR_token="***token***"

variable "path" {
  default = "/vagrant/t11"
}

variable "repo_name" {}

variable "list_of_files" {
    default = [
      "provider.tf",
      "st_dep.tf",
      "st_srv.tf",
      "var.tf",
      "terraform.tfvars",
      "github.tf"
    ]
}