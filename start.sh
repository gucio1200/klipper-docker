#!/bin/bash
docker-compose pull --no-parallel \
	&& docker-compose stop \
        && docker-compose up -d
#	&& docker-compose rm -f \
#	&& docker volume rm $(docker volume ls)
