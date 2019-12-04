#!/bin/bash
env
#Configure misp-dashboard
sed -i "s#host = localhost#host = 0.0.0.0#" config/config.cfg
sed -i "s#host=localhost#host=$REDISHOST#" config/config.cfg
sed -i "s#port=6250#port=$REDISPORT#" config/config.cfg
sed -i "s#misp_web_url = http://0.0.0.0#misp_web_url=$MISP_URL#" config/config.cfg

sed -i "s#\"url\": \"http://localhost\"#\"url\": \"$MISP_URL\"#" config/config.cfg
sed -i "s#\"zmq\": \"tcp://localhost:50000\"#\"zmq\": \"tcp://$ZMQ_URL:$ZMQ_PORT\"#" config/config.cfg

cat config/config.cfg

#Run misp-dashboard
echo "Enabling virtualenv"
. ./DASHENV/bin/activate
echo "Starting zmq"
./start_zmq.sh
echo "Starting server"
./server.py
