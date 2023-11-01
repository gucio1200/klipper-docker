#!/bin/bash
sh -c '/home/klippy/venv/bin/python /home/klippy/klipper/scripts/graph_accelerometer.py -c $(ls -t /tmp/raw_data_axis*_belt-tension-*.csv | head -n 2) -o /tmp/belt-tension-resonances-$( date +'%Y-%m-%d-%H%M%S' ).png'
