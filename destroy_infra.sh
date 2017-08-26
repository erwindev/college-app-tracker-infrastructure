#!/bin/sh

BASEDIR=$(pwd)
cd $BASEDIR/infrastructure/$1
source env.sh

echo "Destroy infrastructure..."
terraform destroy