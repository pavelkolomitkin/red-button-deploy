#!/usr/bin/env bash

# shut down the compose if it's running
echo -n 'Stop previous containers...'
echo -en '\n'
docker-compose stop

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

# up docker compose
echo -en '\n'
echo -n 'Up docker compose...'
echo -en '\n'
docker-compose up -d

# install composer dependencies(use keys --no-dev --optimize-autoloader)
echo -en '\n'
echo -n 'Install compose dependencies...'
echo -en '\n'
docker exec php-fpm-container composer install --no-dev --optimize-autoloader

# run database migrations
echo -en '\n'
echo -n 'Run database migrations...'
echo -en '\n'
until docker exec php-fpm-container php bin/console doctrine:migrations:migrate --env=prod --no-interaction
do
    echo -en '\n'
    echo -n 'Waiting postgres...'
    echo -en '\n'

    sleep 10

    echo -en '\n'
    echo -n 'And try again to run migrations...'
    echo -en '\n'
done

# clear cache env=prod
echo -en '\n'
echo -n 'Clear cache...'
echo -en '\n'
docker exec php-fpm-container php bin/console clear:cache --env=prod



