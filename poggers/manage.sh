#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init() {
		docker build -t poggers git@github.com:EerikSaksi/poggers.git\#main: 
		docker run --rm --name postgraphile-ssl-chinook -p 5000:5000  -e DATABASE_URL=$DATABASE_URL -e PORT=5000  postgraphile_ssl
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
