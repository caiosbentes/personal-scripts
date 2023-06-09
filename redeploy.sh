#!/bin/bash

# Define options as an associative array
declare -A clusters=(
  [1]="jaas-bbn"
  [2]="jaas-prod"
)

# Prompt user for cluster choice
echo "Please select a cluster:"
for key in "${!clusters[@]}"; do
  echo "$key. ${clusters[$key]}"
done

read -rp "Enter your choice [1-2]: " choice

# Handle user input
case $choice in
  1)
    echo "You selected $cluster1."
    kubectx "${clusters[$choice]}" && cd config_files/bbn-production &&  git checkout master && git pull
    ;;
  2)
    echo "You selected $cluster2."
    kubectx "${clusters[$choice]}" && cd /config_files/cos-production &&  git checkout master && git pull 
    ;;
  *)
    echo "Invalid choice. Please enter a number between 1 and 2."
    exit 1
    ;;
esac

# Prompt user for input
echo "Enter instance name: "
read -r instance

# Validate input
if [[ -z "$instance" ]]; then
  echo "Error: instance name is empty."
  exit 1
fi

# Decommission instance
helm uninstall "$instance" -n jenkins-instances

# Install a JaaS instance
helm install "$instance" helm-keysight/jenkins-helm -n jenkins-instances -f "$instance".yaml
