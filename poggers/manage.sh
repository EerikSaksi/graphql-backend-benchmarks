#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
    N_CPUS=$(nproc --all)
		docker build -t poggers git@github.com:EerikSaksi/poggers.git\#main: 
		docker run -d --name poggers-chinook -p 8080:8080 -e SERVER_ADDR=0.0.0.0:8080 -e PG.USER=admin -e PG.HOST=172.17.0.1 -e PG.PORT=7432 -e PG.DBNAME=chinook -e PG.POOL.MAX_SIZE=100 poggers 
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
				docker start poggers-chinook
        exit
        ;;
    stop)
        docker stop poggers-chinook
        exit
        ;;
    nuke)
        docker stop poggers-chinook
        docker rm poggers-chinook
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
