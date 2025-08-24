#!/bin/sh

if [ -z "$SHELLED" ]; then
    export SHELLED=1
    exec "$SHELL" "$0" "$@"
fi

ansible-playbook -i ../inventory/hosts.yml ../playbook/destroy.yml
