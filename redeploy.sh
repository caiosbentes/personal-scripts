#!/bin/bash

# Define options
cluster1="jaas-bbn"
cluster2="jaas-prod"

# Prompt user for input
echo "Please select an option:"
echo "1. $cluster1"
echo "2. $cluster2"
read -p "Enter your choice [1-2]: " choice

# Handle user input
case $choice in
  1)
    echo "You selected $cluster1."
    kubectx $cluster1 && cd config_files/bbn-production && git pull
    ;;
  2)
    echo "You selected $cluster2."
    kubectx $cluster2 && cd /config_files/cos-production && git pull 
    ;;
  *)
    echo "Invalid choice. Please enter a number between 1 and 2."
    exit 1
    ;;
esac

# Prompt user for input
read -p "Enter your name: " instance

# Validate input
if [[ -z "$instance" ]]; then
  echo "Error: name is empty."
  exit 1
fi

# Decommission instance
helm uninstall $instance -n jenkins-instances

# Install a JaaS instance
helm install $INSTANCE helm-keysight/jenkins-helm -n jenkins-instances -f $instance.yaml
