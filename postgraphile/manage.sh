#!/usr/bin/env sh
set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
    docker build --no-cache -t "hasura/postgraphile:latest" "$SCRIPT_DIR"
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
				docker run --rm -m 8192m --cpus=$SERVER_CPUS --name postgraphile-chinook -p 5000:5000 -d hasura/postgraphile:latest postgraphile -c 'postgres://admin@172.17.0.1:7432/chinook' --host 0.0.0.0 --max-pool-size 100 --cluster-workers $SERVER_CPUS
				sleep 10
        exit
        ;;
    stop)
        docker stop postgraphile-chinook
        exit
        ;;
    nuke)
        docker stop postgraphile-chinook
        docker rm postgraphile-chinook
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
