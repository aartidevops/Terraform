module "component" {
  for_each = var.component
  source = "./resources"
  component = each.value["name"]
  vm_size = each.value["vm_size"]
}


variable "component" {
  default = {

    frontend = {
      name    = "workstation"
      vm_size = "Standard_B4ms"
    }
    mongodb = {
      name = "vault"
      vm_size = "Standard_B4ms"
    }
  }
}