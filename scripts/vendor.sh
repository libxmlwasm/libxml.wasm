#!/bin/bash -e

for script in $(dirname $0)/vendor/*.sh; do
  $script
done
