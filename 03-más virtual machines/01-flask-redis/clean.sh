#!/bin/bash

source "${PWD}/config.ini"
source "color.sh"

delete_redis_server() {
  echo "$(red_text "[-] Deleting VM:") $redis_server (img: $redis_image) ..."
  gcloud compute instances delete $redis_server --quiet
  echo "$(red_text "[-] Deleting:") $redis_server done!"
}

delete_firewall_rules() {
  echo "$(red_text "[-] Deleting firewall rules: $app_port") ..."

  gcloud compute firewall-rules delete "default-allow-external-$app_port" --quiet

  echo "$(red_text "[-] Deleting firewall rules:") done!"
}

delete_app() {
  echo "$(red_text "[-] Deleting App:") $app_name ..."
  gcloud compute instances delete $app_name --quiet
  echo "$(red_text "[-] All the resources were deleted succesfully! 🍰 🍰 🍰")"
}

delete_firewall_rules
delete_redis_server
delete_app
