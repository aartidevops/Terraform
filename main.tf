module "component" {
  for_each = var.component
  source = "./resources"
  component = each.value["name"]
  vm_size = each.value["vm_size"]
}


variable "component" {
  default = {

    frontend = {
      name    = "frontend"
      vm_size = "Standard_B4ms"
    }
    mongodb = {
      name = "mongodb"
      vm_size = "Standard_B4ms"
    }
    catalogue = {
      name = "catalogue"
      vm_size = "Standard_B4ms"
    }

    user = {
      name = "user"
      vm_size = "Standard_B4ms"
    }

    cart = {
      name = "cart"
      vm_size = "Standard_D2as_v4"
    }

    mysql = {
      name = "mysql"
      vm_size = "Standard_D2as_v4"
    }

    shipping = {
      name = "shipping"
      vm_size = "Standard_D2as_v4"
    }

    payment = {
      name = "payment"
      vm_size = "Standard_D2as_v4"
    }

    redis = {
      name = "redis"
      vm_size = "Standard_D2as_v4"
    }

    dispatch = {
      name = "dispatch"
      vm_size = "Standard_D2as_v4"
    }

    rabbitmq = {
      name = "rabbitmq"
      vm_size = "Standard_D2as_v4"
    }
  }
}