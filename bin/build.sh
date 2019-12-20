#!/usr/bin/env bash

gem install mongo -v 2.10.2
docker-compose up --remove-orphans -d --build