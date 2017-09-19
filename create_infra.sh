#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Incorrect number of parameters: usage 'create_infra.sh <env> <config|no-config>"
    exit 0
fi

# Start AWS Provisioning
BASEDIR=$(pwd)
cd $BASEDIR/infrastructure/$1
source env.sh

echo "Apply terraform scripts..."
terraform apply
cd ../config_generator

echo "Generate ansible ssh config settings..."
python config_generator.py $1 ansible_ssh_cfg > ssh.cfg
cp ssh.cfg $BASEDIR/configuration

echo "Generate ansible invetory hosts..."
python config_generator.py $1 inventory > inventory
cp inventory $BASEDIR/configuration

echo "Generate ssh config..."
python config_generator.py $1 ssh_config > config
cp config ~/.ssh

if [ "$2" == "no-config" ]; then
	echo "Done"
	exit 0
fi

# Sleep for 2 minutes to give AWS a chance to finish provisioning
sleep 2m

# Start Ansible Configuration
cd $BASEDIR/configuration

echo "Update CI Software..."
ansible-playbook -i inventory ci.yml

echo "Update Docker Server sofware..."
ansible-playbook -i inventory docker_server.yml

echo "Create swarm..."
ansible-playbook -i inventory swarm_create.yml

echo "Done"
