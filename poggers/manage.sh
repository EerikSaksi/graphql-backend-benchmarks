#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
    N_CPUS=$(nproc --all)
		docker build -t poggers git@github.com:EerikSaksi/poggers.git\#main: 
		docker run -d -m 8192m --cpus=$CPUS --name poggers-chinook -p 8080:8080 -e DATABASE_URL='postgres://admin@172.17.0.1:7432/chinook' -e SERVER_ADDR=0.0.0.0:8080 -e POOL_SIZE=100 poggers 
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
