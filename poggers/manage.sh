#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
    N_CPUS=$(nproc --all)
		docker build git@github.com:EerikSaksi/poggers.git#main: -t poggers
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

case $1 in
    init)
        init
        exit
        ;;
    start)
        docker start postgres-chinook 
        docker start poggers
        exit
        ;;
    stop)
        docker stop postgraphile-chinook
        exit
        ;;
    nuke)
        docker stop postgraphile-chinook
        docker rm poggers
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
