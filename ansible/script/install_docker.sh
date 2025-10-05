#!/usr/bin/env bash
set -euo pipefail

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
else
    echo "Cannot detect OS. /etc/os-release missing."
    exit 1
fi

check_docker_installed() {
    command -v docker >/dev/null 2>&1
}

check_docker_healthy() {
    systemctl is-active --quiet docker && systemctl is-enabled --quiet docker
}

check_compose_installed() {
    command -v docker-compose >/dev/null 2>&1 || docker compose version >/dev/null 2>&1
}

if check_docker_installed && check_docker_healthy && check_compose_installed; then
    docker --version
    docker compose version || docker-compose --version
    exit 0
fi

if [[ "$ID_LIKE" == *"debian"* ]] || [[ "$ID" == "debian" ]] || [[ "$ID" == "ubuntu" ]]; then
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL "https://download.docker.com/linux/${ID}/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
    fi

    if ! grep -q "download.docker.com" /etc/apt/sources.list.d/docker.list 2>/dev/null; then
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${ID} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

elif [[ "$ID_LIKE" == *"rhel"* ]] || [[ "$ID" == "fedora" ]] || [[ "$ID" == "centos" ]]; then
    sudo dnf -y install dnf-plugins-core
    if ! sudo dnf repolist | grep -q docker-ce; then
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || true
    fi
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Unsupported OS: $NAME ($ID)"
    exit 1
fi

sudo systemctl enable docker
sudo systemctl start docker

if ! check_compose_installed; then
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.30.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
fi

docker --version || exit 1
docker compose version || docker-compose --version
