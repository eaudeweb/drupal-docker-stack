#!/usr/bin/env sh

COMPOSE_FILES="-f compose.yml"
if [ -f app.yml ]; then
	COMPOSE_FILES="${COMPOSE_FILES} -f app.yml "
fi
echo "\033[0;32mUsing compose files: ${COMPOSE_FILES}\033[0m"

# Start all services
# PROFILES="--profile=*"
PROFILES="--profile=varnish --profile=solr --profile=mariadb"
echo "\033[0;32mUsing profile(s)   : ${PROFILES}\033[0m"

# Example commands
# Start reverse proxy - docker compose ${PROFILES} ${COMPOSE_FILES} up -d
# Start database      - docker compose ${PROFILES} ${COMPOSE_FILES} up -d
# Start Solr search   - docker compose ${PROFILES} ${COMPOSE_FILES} up -d

# Start stack
docker compose ${PROFILES} ${COMPOSE_FILES} up -d