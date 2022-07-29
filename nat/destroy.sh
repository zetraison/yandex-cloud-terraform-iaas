#!/bin/bash

set -eu

echo "Start destroying terraform infrastructure"

TF_IN_AUTOMATION=1 terraform destroy -auto-approve

echo "End destroying"