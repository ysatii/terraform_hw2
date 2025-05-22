#variable vm_db_instance_name{
#  type        = string
#  default     = "netology-develop-platform-db"
#  description = "instance name"
#}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "VM platform type"
}

variable "vm_db_platform_configs" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    "standard-v1" = {
      cores         = 2
      memory        = 4
      core_fraction = 5
    }
    "standard-v2" = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }

  description = "Platform resource configurations b zone"
}

variable "vpc_name_b" {
  type        = string
  default     = "develop_b"
  description = "VPC network & subnet name"
}

variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}