#!/usr/bin/env bash

echo -n 'Importing regions...'
echo -en '\n'
docker exec -i postgres-db-container psql -U postgres red-button-prod < ./backend_src/docker/common/data/regions.pgsql

echo -n 'Importing companies...'
echo -en '\n'
docker exec -i postgres-db-container psql -U postgres red-button-prod < ./backend_src/docker/common/data/companies.pgsql