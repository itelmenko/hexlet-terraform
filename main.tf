// main.tf - имя файла выбрано произвольно, важно только расширение
terraform {
  required_providers {
    // Здесь указываются все провайдеры, которые будут использоваться
    digitalocean = {
      source = "digitalocean/digitalocean"
      // Версия может обновиться
      version = "~> 2.0"
    }
  }
}

// Terraform должен знать ключ, для выполнения команд по API

// Определение переменной, которую нужно будет задать
variable "do_token" {}

// Установка значения переменной
provider "digitalocean" {
  token = var.do_token
}

// Пример взят из документации
// web - произвольное имя ресурса
resource "digitalocean_droplet" "web1" {
  image  = "ubuntu-22-04-x64"
  // Имя внутри Digital Ocean
  // Задается для удобства просмотра в веб-интерфейсе
  name   = "web-1"
  // Регион, в котором располагается датацентр
  // Выбирается по принципу близости к клиентам
  region = "ams3"
  // Тип сервера, от этого зависит его мощность и стоимость
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "web2" {
  image  = "ubuntu-22-04-x64"
  name   = "web-2"
  region = "ams3"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "web3" {
  image  = "ubuntu-22-04-x64"
  name   = "web-3"
  region = "ams3"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [
    digitalocean_droplet.web1.id,
    digitalocean_droplet.web2.id,
    digitalocean_droplet.web3.id,
  ]
}