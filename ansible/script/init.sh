#!/usr/bin/env bash

set -euo pipefail

. ./env.sh

PLAYBOOK="../playbook/init.yml"
INVENTORY="../inventory/hosts.yml"

usage() {
    echo "Usage: $0 [local|remote] [hostname (for remote)]"
    echo
    echo "Examples:"
    echo "  $0 local"
    echo "  $0 remote remote1"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

MODE=$1
HOST=${2:-}

case "$MODE" in
    local)
        echo "Running playbook locally..."
        ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --limit localhost
        ;;

    remote)
        if [ -z "$HOST" ]; then
            echo "Error: Remote host name required."
            usage
        fi
        echo "Running playbook against remote: $HOST"
        ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --limit "$HOST"
        ;;

    *)
        usage
        ;;
esac
