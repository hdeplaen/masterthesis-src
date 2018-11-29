#!/bin/bash

echo 'starting privacy peers...'

cd localhostPP0
nohup ./startup.sh &

cd ../localhostPP1
nohup ./startup.sh &

cd ../localhostPP2
nohup ./startup.sh &


echo 'starting input peers in 2s...'
sleep 2

cd ../localhostIP0
nohup ./startup.sh &

cd ../localhostIP1
nohup ./startup.sh &

cd ../localhostIP2
nohup ./startup.sh &
