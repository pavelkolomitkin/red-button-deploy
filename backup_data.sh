#!/usr/bin/env bash

echo -n 'Backup database...'
echo -en '\n'
docker exec -i postgres-db-container pg_dump -U postgres red-button-prod > ./data/dump_$(date +%Y_%m_%d_%H_%M_%S).pgsql