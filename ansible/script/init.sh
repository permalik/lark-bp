#!/usr/bin/env bash

. ./env.sh
ansible-playbook -i ../inventory/hosts.yml ../playbook/init.yml
