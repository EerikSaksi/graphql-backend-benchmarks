#!/bin/bash

# Run the CLI in container, with "localhost" network shared and current directory mounted at "/app/tmp"
# The CLI tries to look up the config file from process.cwd()/<filepath>, and the WORKDIR is set to /app so CWD is always "/app"
# So you need to use a relative path from /app to where you mounted your config files.
# IE if your config YAML on host system are in (current directory, AKA "$PWD"), then you should mount $PWD to "/app/<something>"
# And then use "./something" as base directory for config + report output paths.

# SCRIPT_DIR points to the absolute path of this file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


#docker kill $(docker ps -q)
#./poggers/manage.sh start
#docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
#  graphql-bench-local:latest query \
#  --config="./tmp/poggers/bench.yaml" \
#  --outfile="./tmp/results/poggers_report.json"

docker kill $(docker ps -q)
./hasura/manage.sh start
docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
  graphql-bench-local:latest query \
  --config="./tmp/hasura/bench.yaml" \
  --outfile="./tmp/results/hasura_report.json"
./hasura/manage.sh stop

#docker kill $(docker ps -q)
#./postgraphile/manage.sh start
#docker run --rm --net=host -v "$SCRIPT_DIR":/app/tmp -it \
#  graphql-bench-local:latest query \
#  --config="./tmp/postgraphile/bench.yaml" \
#  --outfile="./tmp/results/postgraphile_report.json"

python3 data_analysis.py
