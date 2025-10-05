#!/usr/bin/env bash

set -euo pipefail

. ./env.sh

PLAYBOOK="../playbook/deploy.yml"
INVENTORY="../inventory/hosts.yml"

usage() {
    echo "Usage: $0 [local|remote] [hostname (for remote)] [service]"
    echo
    echo "Examples:"
    echo "  $0 local web"
    echo "  $0 remote remote1 api"
    echo "  $0 local all"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

MODE=$1
SERVICE_OR_HOST=${2:-}
SERVICE=${3:-all}

case "$MODE" in
    local)
        echo "Running playbook locally for service '$SERVICE_OR_HOST'..."
        ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --limit localhost -e "deploy_target=$SERVICE_OR_HOST"
        ;;

    remote)
        if [ -z "$SERVICE_OR_HOST" ]; then
            echo "Error: Remote host name required."
            usage
        fi
        echo "Running playbook against remote '$SERVICE_OR_HOST' for service '$SERVICE'..."
        ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --limit "$SERVICE_OR_HOST" -e "deploy_target=$SERVICE"
        ;;

    *)
        usage
        ;;
esac
