#!/bin/bash
./hasura/manage.sh nuke
./hasura/manage.sh init
./postgraphile/manage.sh nuke
./postgraphile/manage.sh init
./poggers/manage.sh nuke
./poggers/manage.sh init
