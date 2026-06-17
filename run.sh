#!/bin/bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ENV_FILE=".env"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_PATH="$SCRIPT_DIR/$ENV_FILE"

usage() {
    echo -e "${BOLD}Usage:${NC}"
    echo -e "  ${GREEN}./run.sh${NC} ${DIM}<project1> [project2...]${NC}   Pusher des projets"
    echo -e "  ${GREEN}./run.sh --setup${NC}                        Reconfigurer les paramètres"
    echo -e "  ${GREEN}./run.sh --setup${NC} ${DIM}<project1> [...]${NC}    Reconfigurer puis pusher"
    echo ""
}

prompt() {
    local label="$1"
    local hint="${2:-}"
    local secret="${3:-false}"

    if [[ -n "$hint" ]]; then
        echo -e "  ${YELLOW}${label}${NC} ${DIM}(${hint})${NC}"
    else
        echo -e "  ${YELLOW}${label}${NC}"
    fi

    if [[ "$secret" == "true" ]]; then
        read -rsp "  > " value
        echo ""
    else
        read -rp "  > " value
    fi

    echo "$value"
}

setup() {
    echo ""
    echo -e "${BOLD}${BLUE}Configuration${NC}"
    echo -e "${DIM}Les paramètres seront sauvegardés dans ${ENV_FILE}.${NC}"
    echo ""

    gh_token=$(prompt \
        "GitHub Personal Access Token" \
        "scopes requis : repo, delete_repo" \
        "true")

    source_user=$(prompt \
        "Nom d'utilisateur GitHub source" \
        "compte depuis lequel cloner les repos, ex: aymnms")

    ssh_input=$(prompt \
        "Chemin vers vos clés SSH" \
        "laisser vide pour ~/.ssh")

    ssh_dir="${ssh_input:-$HOME/.ssh}"
    ssh_dir="${ssh_dir/#\~/$HOME}"

    cat > "$ENV_PATH" <<EOF
GH_TOKEN=$gh_token
SOURCE_GITHUB_USER=$source_user
SSH_DIR=$ssh_dir
EOF

    echo ""
    echo -e "${GREEN}Configuration sauvegardée.${NC}"
    echo ""
}

build() {
    echo -e "${BLUE}Building image Docker...${NC}"
    docker compose --project-directory "$SCRIPT_DIR" build --quiet
    echo -e "${GREEN}Image prête.${NC}"
    echo ""
}

run_push() {
    echo -e "${BLUE}Lancement pour :${NC} $*"
    echo ""
    docker compose --project-directory "$SCRIPT_DIR" run --rm push "$@"
    echo ""
    echo -e "${GREEN}Terminé. Le container a été supprimé.${NC}"
}

# ── Parse args ──────────────────────────────────────────────────────────────

FORCE_SETUP=false
PROJECTS=()

for arg in "$@"; do
    if [[ "$arg" == "--setup" ]]; then
        FORCE_SETUP=true
    else
        PROJECTS+=("$arg")
    fi
done

if [[ "$FORCE_SETUP" == false && ${#PROJECTS[@]} -eq 0 ]]; then
    usage
    exit 1
fi

# ── Setup si nécessaire ──────────────────────────────────────────────────────

if [[ "$FORCE_SETUP" == true || ! -f "$ENV_PATH" ]]; then
    if [[ ! -f "$ENV_PATH" ]]; then
        echo -e "${YELLOW}Aucune configuration trouvée. Lancement du setup initial.${NC}"
    fi
    setup
fi

# Charger le .env
set -o allexport
# shellcheck source=.env
source "$ENV_PATH"
set +o allexport

# ── Build + Run ──────────────────────────────────────────────────────────────

if [[ ${#PROJECTS[@]} -gt 0 ]]; then
    build
    run_push "${PROJECTS[@]}"
fi
