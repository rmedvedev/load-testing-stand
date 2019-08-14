#!/usr/bin/env bash

set -e

OPEN_GRAFANA=false

err() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&2
}

log(){
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&1
}

#Open grafana in default browser
openGrafana(){
    timeout 60 bash -c '
    until (curl --output /dev/null --silent --head --fail http://localhost:3000); do     
    sleep 1; 
    done;'
    python -mwebbrowser http://localhost:3000/d/metrics/overload > /dev/null  &
}

while [ "$1" != "" ]; do
    case $1 in
        "--open-grafana") shift
                        OPEN_GRAFANA='true'
                        ;;
    esac
    shift || true
done

log "Start grafana"
docker-compose up -d grafana

${OPEN_GRAFANA} && log "Open grafana" && openGrafana

log "Start load testing"
docker-compose run --rm tank -qc config.yml