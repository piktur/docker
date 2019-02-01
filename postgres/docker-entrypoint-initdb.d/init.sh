#!/bin/bash

set -e

args=(--variable ON_ERROR_STOP=1 -U $POSTGRES_USER)
db_exist="SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'"
db_create="CREATE DATABASE $POSTGRES_DB TEMPLATE template0;"
db_grant="GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;"

psql "${args[@]}" --tuples-only --command "$db_exist" | grep -q 1 || psql "${args[@]}" --command "$db_create $db_grant"
