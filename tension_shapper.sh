#!/bin/bash
docker exec -ti klipper sh -c 'rm /tmp/*.csv'
docker exec -ti klipper sh -c 'echo "G28" > /tmp/printer'
docker exec -ti klipper sh -c 'echo "TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data" > /tmp/printer'
docker exec -ti klipper sh -c 'echo "TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data" > /tmp/printer'
