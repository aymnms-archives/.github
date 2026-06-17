#!/bin/bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DARK_GRAY='\033[1;30m'
NC='\033[0m'

SOURCE_USER="${SOURCE_GITHUB_USER:-aymnms}"
DEST_ORG="aymnms-archives"
API="https://api.github.com"

for project_name in "$@"
do
    echo -e "${BLUE}push.sh > start $project_name${NC}"

    if (
        echo -e "${DARK_GRAY}Cloning ${SOURCE_USER}/${project_name} (mirror)...${NC}"
        git clone --mirror "https://oauth2:${GH_TOKEN}@github.com/${SOURCE_USER}/${project_name}.git" "${project_name}.git"

        cd "${project_name}.git"

        status=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "Authorization: Bearer ${GH_TOKEN}" \
            "${API}/repos/${DEST_ORG}/${project_name}")

        if [[ "$status" == "200" ]]; then
            echo -e "${DARK_GRAY}${DEST_ORG}/${project_name} already exists, skipping creation${NC}"
        else
            echo -e "${DARK_GRAY}Creating ${DEST_ORG}/${project_name}...${NC}"
            curl -s -X POST \
                -H "Authorization: Bearer ${GH_TOKEN}" \
                -H "Content-Type: application/json" \
                "${API}/orgs/${DEST_ORG}/repos" \
                -d "{\"name\": \"${project_name}\", \"private\": false}" > /dev/null
        fi

        echo -e "${DARK_GRAY}Pushing all branches and tags...${NC}"
        git push --mirror "git@github.com:${DEST_ORG}/${project_name}.git"
    ); then
        echo -e "${GREEN}push.sh > $project_name pushed to ${DEST_ORG}${NC}"
    else
        echo -e "${RED}push.sh > $project_name failed, skipping${NC}"
    fi

    rm -rf "${project_name}.git" 2>/dev/null || true
    echo -e "${BLUE}push.sh > $project_name local folder removed${NC}"
done
