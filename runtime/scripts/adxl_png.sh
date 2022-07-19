#!/bin/bash
sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/calibrate_shaper.py $(ls -t /tmp/calibration_data_y* | head -n 1) -o /tmp/shaper_y_$(date +%d-%m-%Y_%H-%M-%S).png'
sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/calibrate_shaper.py $(ls -t /tmp/calibration_data_x* | head -n 1) -o /tmp/shaper_x_$(date +%d-%m-%Y_%H-%M-%S).png'
