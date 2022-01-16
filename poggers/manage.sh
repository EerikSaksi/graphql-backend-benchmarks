#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
		docker build -t poggers git@github.com:EerikSaksi/poggers.git\#main: 
		docker run -d --name poggers-chinook --network=host -e DATABASE_URL=$DATABASE_URL -e SERVER_ADDR='127.0.0.1:7080' poggers
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
