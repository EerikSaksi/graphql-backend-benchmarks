#!/usr/bin/env sh

SCRIPT_DIR=$(dirname "$0")
set -e

usage() {
    echo "Usage: $0 (init|start|nuke)"
}


init () {

    # create a volume
    docker volume create --name postgres-chinook

    # initialise postgres
    docker run --rm -v postgres-chinook:/var/lib/postgresql/data -e POSTGRES_USER=admin -e POSTGRES_DB=chinook hasuraci/postgres-init:d7cf835

    # start postgres
    docker run --name postgres-chinook -d -v postgres-chinook:/var/lib/postgresql/data -p 7432:5432 -e POSTGRES_USER=admin hasuraci/postgres-server:d7cf835

    # wait for postgres to come up
    sleep 5

    # Get chinook database
    # wget -O chinook.sql -c 'https://github.com/xivSolutions/ChinookDb_Pg_Modified/raw/pg_names/chinook_pg_serial_pk_proper_naming.sql'

    # copy it into the container
    docker cp "$SCRIPT_DIR/chinook.data" postgres-chinook:/chinook.data
    # import the data
    docker exec postgres-chinook pg_restore -h 127.0.0.1 -p 5432 -U admin -d chinook /chinook.data
		docker run --network=host --name hasura-chinook -e HASURA_GRAPHQL_DATABASE_URL='postgres://postgres:postgres@127.0.0.1:5432/chinook' -e HASURA_GRAPHQL_METADATA_DATABASE_URL=postgres://postgres:postgres@127.0.0.1:5432/hasura_metadata -e HASURA_GRAPHQL_ENABLE_CONSOLE=true -d hasura/graphql-engine:latest graphql-engine serve 
	sleep 10

	#enable foreign key relations (just copied the curl)
	curl 'http://localhost:8080/v1/metadata' \
		-H 'Connection: keep-alive' \
		-H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
		-H 'sec-ch-ua-mobile: ?0' \
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' \
		-H 'sec-ch-ua-platform: "Linux"' \
		-H 'content-type: application/json' \
		-H 'Accept: */*' \
		-H 'Origin: http://localhost:8080' \
		-H 'Sec-Fetch-Site: same-origin' \
		-H 'Sec-Fetch-Mode: cors' \
		-H 'Sec-Fetch-Dest: empty' \
		-H 'Referer: http://localhost:8080/console/data/default/schema/public' \
		-H 'Accept-Language: en-US,en;q=0.9,fi;q=0.8' \
		--data-raw '{"type":"bulk","source":"default","resource_version":2,"args":[{"type":"pg_create_object_relationship","args":{"name":"artist","table":{"name":"albums","schema":"public"},"using":{"foreign_key_constraint_on":"artist_id"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"tracks","table":{"name":"albums","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"tracks","schema":"public"},"column":"album_id"}},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"albums","table":{"name":"artists","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"albums","schema":"public"},"column":"artist_id"}},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"employee","table":{"name":"customers","schema":"public"},"using":{"foreign_key_constraint_on":"support_rep_id"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"invoices","table":{"name":"customers","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"invoices","schema":"public"},"column":"customer_id"}},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"employee","table":{"name":"employees","schema":"public"},"using":{"foreign_key_constraint_on":"reports_to"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"customers","table":{"name":"employees","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"customers","schema":"public"},"column":"support_rep_id"}},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"employees","table":{"name":"employees","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"employees","schema":"public"},"column":"reports_to"}},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"tracks","table":{"name":"genres","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"tracks","schema":"public"},"column":"genre_id"}},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"customer","table":{"name":"invoices","schema":"public"},"using":{"foreign_key_constraint_on":"customer_id"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"invoice_lines","table":{"name":"invoices","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"invoice_lines","schema":"public"},"column":"invoice_id"}},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"invoice","table":{"name":"invoice_lines","schema":"public"},"using":{"foreign_key_constraint_on":"invoice_id"},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"track","table":{"name":"invoice_lines","schema":"public"},"using":{"foreign_key_constraint_on":"track_id"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"tracks","table":{"name":"media_types","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"tracks","schema":"public"},"column":"media_type_id"}},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"playlist_tracks","table":{"name":"playlists","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"playlist_track","schema":"public"},"column":"playlist_id"}},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"playlist","table":{"name":"playlist_track","schema":"public"},"using":{"foreign_key_constraint_on":"playlist_id"},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"track","table":{"name":"playlist_track","schema":"public"},"using":{"foreign_key_constraint_on":"track_id"},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"album","table":{"name":"tracks","schema":"public"},"using":{"foreign_key_constraint_on":"album_id"},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"genre","table":{"name":"tracks","schema":"public"},"using":{"foreign_key_constraint_on":"genre_id"},"source":"default"}},{"type":"pg_create_object_relationship","args":{"name":"media_type","table":{"name":"tracks","schema":"public"},"using":{"foreign_key_constraint_on":"media_type_id"},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"invoice_lines","table":{"name":"tracks","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"invoice_lines","schema":"public"},"column":"track_id"}},"source":"default"}},{"type":"pg_create_array_relationship","args":{"name":"playlist_tracks","table":{"name":"tracks","schema":"public"},"using":{"foreign_key_constraint_on":{"table":{"name":"playlist_track","schema":"public"},"column":"track_id"}},"source":"default"}}]}' \
		--compressed
}

start () {
	docker start hasura-chinook
	docker start postgres-chinook
	sleep 10
}

stop () {
    echo 'stopping raven-chinook container'
    docker stop raven-chinook
}

nuke () {
    docker stop hasura-chinook && docker rm hasura-chinook
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
        start
        exit
        ;;
    stop)
        stop
        exit
        ;;
    nuke)
        nuke
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
