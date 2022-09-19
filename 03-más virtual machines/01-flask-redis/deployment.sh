#!/bin/bash

source "${PWD}/config.ini"
source "color.sh"

PROJECT=$(gcloud config get-value project)
REDIS_VM_IP=""



create_firewall_rules() {
  echo "$(green_text "[+] Opening ports: $app_port") ..."

  gcloud compute firewall-rules create "default-allow-external-$app_port" \
      --direction=INGRESS \
      --priority=1000 \
      --network=default \
      --action=ALLOW \
      --rules=tcp:"$app_port" \
      --source-ranges=0.0.0.0/0 \
      --target-tags=app-server

    echo "$(green_text "[+] Opening ports:") done!"
}

deploy_redis_server() {

  

  echo "$(green_text "[+] Creating VM:") $redis_server (img: ${redis_image}) ..."
  gcloud compute instances create-with-container $redis_server \
      --machine-type="$machine_type" \
      --container-image="$redis_image" \
      --tags=http-server,https-server \
      --quiet
  echo "$(green_text "[+] Deploying:") $redis_server done!"
}

build_and_deploy_app() {
  app_image_uri="eu.gcr.io/$PROJECT/$app_img"

  REDIS_VM_IP=$(gcloud compute instances describe $redis_server --format='get(networkInterfaces[0].networkIP)')

  echo "$(green_text "[+] Building docker image:") $app_image_uri"
  docker build --tag $app_image_uri \
      --build-arg REDIS_IP=$REDIS_VM_IP \
      .

  echo "$(green_text "[+] Publishing docker image:") $app_image_uri"
  docker push "$app_image_uri"

  echo "$(green_text "[+] Deploying App:") $app_name [connected to redis IP: $REDIS_VM_IP]"
  gcloud compute instances create-with-container $app_name \
      --machine-type=$machine_type \
      --container-image=$app_image_uri \
      --tags=app-server \
      --container-env=REDIS_IP_GCP=$REDIS_VM_IP \
      --quiet

  echo "$(green_text "[+] Deployment finished succesfully! 🥳 🥳 🥳")"
}

create_firewall_rules
deploy_redis_server
build_and_deploy_app
