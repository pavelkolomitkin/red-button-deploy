#!/usr/bin/env bash

# shut down the compose if it's running
echo -n 'Stop previous containers...'
echo -en '\n'
docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose-db-migrations.yaml down

# pull the both repositories - backend and frontend
echo -en '\n'
echo 'Pull the source code...'
echo -en '\n'
if [[ ! -d ./backend_src/ ]]
then
    git clone https://github.com/pavelkolomitkin/red-button-backend.git backend_src
fi
cd ./backend_src && git pull origin master && cd ..

if [[ ! -d ./frontend_src/ ]]
then
    git clone https://github.com/pavelkolomitkin/red-button-frontend.git frontend_src
fi
cd ./frontend_src && git pull origin master && cd ..

# build frontend application - the result of building should be passed into the directory ./frontend
/bin/bash ./build-frontend.sh

# up docker compose in order to run database migrations
echo -en '\n'
echo -n 'Up docker compose of database migrations...'
echo -en '\n'
docker-compose -f docker-compose-db-migrations.yaml up -d
docker exec php-container composer install

# run database migrations
echo -en '\n'
echo -n 'Run database migrations...'
echo -en '\n'
until docker exec php-container php bin/console doctrine:migrations:migrate --no-interaction
do
    echo -en '\n'
    echo -n 'Waiting postgres...'
    echo -en '\n'

    sleep 10

    echo -en '\n'
    echo -n 'And try again to run migrations...'
    echo -en '\n'
done

docker-compose -f docker-compose-db-migrations.yaml down

# up docker compose production
echo -en '\n'
echo -n 'Up docker compose production...'
echo -en '\n'
docker-compose -f docker-compose.yaml up -d

docker exec php-fpm-container-prod composer install --no-dev --optimize-autoloader