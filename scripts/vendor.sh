#!/bin/bash -e

embuilder build icu
for script in $(dirname $0)/vendor/*.sh; do
  $script
done
