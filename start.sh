#!/usr/bin/env bash

set -e

err() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&2
}

log(){
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&1
}

openGrafana(){
    timeout 60 bash -c '
    until (curl --output /dev/null --silent --head --fail http://localhost:3000); do     
    sleep 1; 
    done;'
    python -mwebbrowser http://localhost:3000/d/metrics/overload > /dev/null  &
}


log "Start and opening grafana"
docker-compose up -d grafana && openGrafana

log "Start load testing"
docker-compose run --rm tank -qc config.yml