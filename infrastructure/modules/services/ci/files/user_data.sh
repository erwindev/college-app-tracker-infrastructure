#!/bin/bash
apt-add-repository ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible
apt-get install -y python-minimal