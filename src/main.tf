resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family_os
}



resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_instance_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_platform_configs[var.vm_web_platform_id].cores
    memory        = var.vm_web_platform_configs[var.vm_web_platform_id].memory
    core_fraction = var.vm_web_platform_configs[var.vm_web_platform_id].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop_b"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_b
}

resource "yandex_compute_instance" "netology-develop-platform-db" {
  name        = var.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone                      = var.zone_b
  resources {
    cores         = var.vm_db_platform_configs[var.vm_db_platform_id].cores
    memory        = var.vm_db_platform_configs[var.vm_db_platform_id].memory
    core_fraction = var.vm_db_platform_configs[var.vm_db_platform_id].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}