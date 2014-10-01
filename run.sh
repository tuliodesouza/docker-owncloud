#!/bin/bash
service php5-fpm start
service nginx start
while true; do sleep 1d; done
