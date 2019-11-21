#!/bin/bash
env
#Configure misp-dashboard
sed -i "s#host = localhost#host = 0.0.0.0/0#" config/config.cfg
sed -i "s#host=localhost#host=$REDISHOST#" config/config.cfg
sed -i "s#port=6250#port=$REDISPORT#" config/config.cfg
sed -i "s#misp_web_url = http://0.0.0.0#misp_web_url=$MISP_URL#" config/config.cfg

cat config/config.cfg
#Run misp-dashboard
echo "Enabling virtualenv"
. ./DASHENV/bin/activate
echo "Starting zmq subscriber"
./zmq_subscriber.py &
echo "Starting zmq dispatcher"
./zmq_dispatcher.py &
echo "Starting server"
./server.py
