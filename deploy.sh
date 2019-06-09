#!/usr/bin/env bash

# shut down the compose if it's running

# pull the both repositories - backend and frontend
echo -en '\n'
echo "Pull the source code..."
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

echo $(pwd)

# up docker compose

# run database migrations
# clear backend cache