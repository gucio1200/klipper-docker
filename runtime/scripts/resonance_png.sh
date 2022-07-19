#!/bin/bash
sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/graph_accelerometer.py $(ls -t /tmp/raw_data_* | head -n 2) -o /tmp/resonances_xy$(date +%d-%m-%Y_%H-%M-%S).png'
