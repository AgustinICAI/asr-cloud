provider "google" {
  project = "savvy-bay-362807"
  region  = "europe-west1"
  zone    = "europe-west1-d"
}

resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "n1-standard-1"
  boot_disk {
    initialize_params {
      image = "projects/centos-cloud/global/images/centos-7-v20220822"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

