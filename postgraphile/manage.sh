#!/usr/bin/env sh
set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
    N_CPUS=$(nproc --all)
    docker build --no-cache -t postgraphile_ssl "${SCRIPT_DIR}/postgraphile_ssl"
		docker run --name postgraphile-ssl-chinook -d --network=host -e DATABASE_URL="${DATABASE_URL}?ssl=true" -e PORT=5000 postgraphile_ssl
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
        docker start postgraphile-ssl-chinook
        exit
        ;;
    stop)
        docker stop postgraphile-ssl-chinook
        exit
        ;;
    nuke)
        docker stop postgraphile-ssl-chinook
        docker rm postgraphile-ssl-chinook
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
