#!/bin/bash
./hasura/manage.sh init
./hasura/manage.sh stop
./postgraphile/manage.sh init
./postgraphile/manage.sh stop
./poggers/manage.sh init
./postgraphile/manage.sh stop
