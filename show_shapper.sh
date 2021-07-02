#!/bin/bash
docker exec -ti klipper sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/calibrate_shaper.py /tmp/*x*.csv -o /tmp/shaper_calibrate_x.png'
docker exec -ti klipper sh -c '/home/klippy/klippy-env/bin/python /home/klippy/klipper/scripts/calibrate_shaper.py /tmp/*y*.csv -o /tmp/shaper_calibrate_y.png'
