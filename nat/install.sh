#!/bin/bash

set -eu

echo "Start apply terraform infrastructure"

TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve

echo "End applying"