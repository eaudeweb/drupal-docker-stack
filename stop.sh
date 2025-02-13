#!/usr/bin/env sh

# Kill all containers regardless of start profile
docker compose --profile=* kill --signal="SIGTERM"