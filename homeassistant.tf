terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "2.23.1"
        }
    }
}

provider "docker" {
# Also pulls from DOCKER_HOST
    host = "ssh://jqt3of5@tiltpi.equationoftime.tech:22"
    ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_image" "homeassistant" {
    name = "ghcr.io/home-assistant/raspberrypi4-homeassistant:stable"
}

resource "docker_image" "mosquitto" {
    name = "eclipse-mosquitto"
}

resource "docker_container" "ha_container" {
    image = docker_image.homeassistant.image_id
    name = "homeassistant"
    restart = "unless-stopped"
    privileged = true
    network_mode = "host"
    volumes {
            container_path = "/config"
            host_path = "/home/homeassistant/.homeassistant"
    }
    volumes {
            container_path = "/etc/localtime"
            host_path = "/etc/localtime"
            read_only = true
    }
}

resource "docker_container" "mqtt_container" {
    image = docker_image.mosquitto.image_id
    name = "mosquitto"
    ports {
            internal = 1883
            external = 1883
    }
    ports {
            internal = 1883
            external = 1883
            protocol = "udp"
    }
    restart = "unless-stopped"
    volumes {
        container_path = "/mosquitto"
        host_path = "/home/homeassistant/mosquitto"
    }
}