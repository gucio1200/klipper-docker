#!/bin/bash
docker-compose pull --no-parallel && docker-compose stop && docker-compose rm -f && docker-compose up -d
