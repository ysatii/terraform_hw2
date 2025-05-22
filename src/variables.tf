###cloud vars


variable "cloud_id" {
  type        = string
  default         = "b1ggavufohr5p1bfj10e"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default         = "b1g0hcgpsog92sjluneq"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable vm_web_family_os{
  type        = string
  default     = "ubuntu-2004-lts"
  description = "os family"
}

#variable vm_web_instance_name{
#  type        = string
#  default     = "netology-develop-platform-web"
#  description = "instance name"
# }

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM platform type"
}

variable "vm_web_platform_configs" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    "standard-v1" = {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
    "standard-v2" = {
      cores         = 4
      memory        = 8
      core_fraction = 20
    }
  }

  description = "Platform resource configurations"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/8nl4RWFm+0oXUDpUSjuOP3AHCl2E/af1CpzwhtO6 lamer@lamer-VirtualBox"
  description = "ssh-keygen -t ed25519"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
}

variable "metadata" {
  type = map(any)
}
