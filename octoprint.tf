terraform {

}

resource "docker_image" "octoprint" {
    name = "octoprint/octoprint"
}


resource "docker_container" "octoprint_container" {
    image = docker_image.octoprint.image_id
    name = "octoprint"
    restart = "unless-stopped"
    privileged = true
    ports {
        internal = 80
        external = 5000
    }
    volumes {
        container_path = "/octoprint"
        //volume_name="homeassistant_octoprint"
        host_path = "/home/homeassistant/octoprint"
    }
    devices {
        host_path = "/dev/ttyACM0"
    }
}
