#!/bin/bash
docker-compose pull --no-parallel \
	&& docker-compose stop \
	&& docker-compose rm -f \
	&& docker volume rm $(docker volume ls) \
	&& docker-compose up -d
