#!/bin/bash

# Run the CLI in container, with "localhost" network shared and current directory mounted at "/app/tmp"
# The CLI tries to look up the config file from process.cwd()/<filepath>, and the WORKDIR is set to /app so CWD is always "/app"
# So you need to use a relative path from /app to where you mounted your config files.
# IE if your config YAML on host system are in (current directory, AKA "$PWD"), then you should mount $PWD to "/app/<something>"
# And then use "./something" as base directory for config + report output paths.

# SCRIPT_DIR points to the absolute path of this file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



for i in {1..15};
	do 
		export DB_CPUS=$((i))
		export SERVER_CPUS="$((16 - i))";
		echo "$Server CPUs: ${SERVER_CPUS}, Database CPUs: ${DB_CPUS}"
		docker kill $(docker ps -q)
		./poggers/manage.sh start
		sleep 5
		docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
			graphql-bench-local:latest query \
			--config="./tmp/poggers/bench.yaml" \
			--outfile="./tmp/results/poggers_report.json"

		docker kill $(docker ps -q)

		./hasura/manage.sh start
		sleep 5
		docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
			graphql-bench-local:latest query \
			--config="./tmp/hasura/bench.yaml" \
			--outfile="./tmp/results/hasura_report.json"
		./hasura/manage.sh stop


		docker kill $(docker ps -q)
		./postgraphile/manage.sh start
		sleep 5
		docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
			graphql-bench-local:latest query \
			--config="./tmp/postgraphile/bench.yaml" \
			--outfile="./tmp/results/postgraphile_report.json"

		mkdir results/"${SERVER_CPUS}_server_cpus_${DB_CPUS}_db_cpus"
		mv results/*json results/"${SERVER_CPUS}_server_cpus_${DB_CPUS}_db_cpus"
done
