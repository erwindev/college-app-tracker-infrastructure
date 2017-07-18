#!/bin/bash
apt-add-repository ppa:ansible/ansible
apt-get -y update
apt-get -y upgrade
apt-get -y install ansible
