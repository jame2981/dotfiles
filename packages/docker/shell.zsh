# Docker shell integration

# macOS + colima: ensure DOCKER_HOST is set
if [[ "$OSTYPE" == darwin* ]]; then
    if [ -S "$HOME/.colima/default/docker.sock" ]; then
        export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
    fi
fi

# Compose V2 compatibility alias (docker compose -> docker-compose)
if ! command -v docker-compose &>/dev/null && command -v docker &>/dev/null; then
    alias docker-compose='docker compose'
fi
