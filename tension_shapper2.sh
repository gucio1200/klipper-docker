#!/bin/bash
docker exec -ti klipper sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances_$(date +%d-%m-%Y_%H-%M-%S).png'
