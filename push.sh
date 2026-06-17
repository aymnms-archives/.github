#!/bin/bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DARK_GRAY='\033[1;30m'
NC='\033[0m'

SOURCE_USER="${SOURCE_GITHUB_USER:-aymnms}"

for project_name in "$@"
do
    echo -e "${BLUE}push.sh > start $project_name${NC}"

    echo -e "${DARK_GRAY}Cloning ${SOURCE_USER}/${project_name}...${NC}"
    gh repo clone "${SOURCE_USER}/${project_name}" "${project_name}"

    cd "$project_name" || { echo -e "${RED}push.sh > Failed to enter $project_name${NC}"; continue; }

    if gh repo view "aymnms-archives/${project_name}" &>/dev/null; then
        echo -e "${DARK_GRAY}aymnms-archives/${project_name} already exists, skipping creation${NC}"
    else
        echo -e "${DARK_GRAY}Creating aymnms-archives/${project_name}...${NC}"
        gh repo create aymnms-archives/"$project_name" --public
    fi

    git remote remove origin
    git remote add origin git@github.com:aymnms-archives/"$project_name".git

    # Push the code
    current_branch=$(git symbolic-ref --short HEAD)
    echo -e "${DARK_GRAY}Pushing branch: $current_branch${NC}"
    git push -u origin "$current_branch"

    echo -e "${GREEN}push.sh > $project_name pushed to aymnms-archives${NC}"

    cd ..
    rm -rf "$project_name"
    echo -e "${BLUE}push.sh > $project_name local folder removed${NC}"
done
