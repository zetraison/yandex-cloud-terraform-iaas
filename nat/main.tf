variable "linux_image_id" {
  type        = string
  description = "Image ID for VM."
  default     = "fd826dalmbcl81eo5nig"
}

variable "nat_image_id" {
  type        = string
  description = "Image ID for NAT server."
  default     = "fd8phfma88csn6br814r"
}

variable "cidr_block_private_subnet" {
  type        = string
  description = "CIDR block for private subnet."
  default     = "10.129.0.0/24"
}

variable "cidr_block_public_subnet" {
  type        = string
  description = "CIDR block for public subnet."
  default     = "10.130.0.0/24"
}

resource "yandex_vpc_network" "lab-net" {
  name = "lab-net"
}

resource "yandex_vpc_subnet" "lab-net-public-subnet" {
  name           = "lab-net-public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = [var.cidr_block_public_subnet]
}

resource "yandex_vpc_subnet" "lab-net-private-subnet" {
  name           = "lab-net-private-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = [var.cidr_block_private_subnet]
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab-net-public-subnet.id
    nat       = true
  }

  metadata = {
    user-data : "${file("./user-data.config")}"
  }
}

resource "yandex_compute_instance" "private-vm" {
  name = "private-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.linux_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab-net-private-subnet.id
    nat       = false
  }

  metadata = {
    user-data : "${file("./user-data.config")}"
  }
}

resource "yandex_vpc_route_table" "lab-rt-a" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.lab-net.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}