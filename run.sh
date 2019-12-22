#!/bin/sh
env

## config
if [ -e "config/config.cfg" ]; then
    diff -u config/config.cfg.default config/config.cfg
    if [ "$?" == "0" ]; then
        cp -f config/config.cfg.default config/config.cfg
    else
        echo "Your config has changes, giving you a chance to see the changes and decide if you want to overwrite"
        cp -i config/config.cfg.default config/config.cfg
    fi
else
    cp -i config/config.cfg.default config/config.cfg
    echo "Sanitizing MaxMindDB Path"
    sed -i "s|pathMaxMindDB=./data/GeoLite2-City/GeoLite2-City.mmdb|pathMaxMindDB=$PWD/data/GeoLite2-City/GeoLite2-City.mmdb|" config/config.cfg
    sed -i "s|path_countrycode_to_coord_JSON=./data/country_code_lat_long.json|path_countrycode_to_coord_JSON=$PWD/data/country_code_lat_long.json|" config/config.cfg
fi



#Configure misp-dashboard
sed -i "s#host = localhost#host = 0.0.0.0#" config/config.cfg
sed -i "s#host=localhost#host=$REDISHOST#" config/config.cfg
sed -i "s#port=6250#port=$REDISPORT#" config/config.cfg
sed -i "s#misp_web_url = http://0.0.0.0#misp_web_url=$MISP_URL#" config/config.cfg

sed -i "s#misp_fqdn = https://misp.local#misp_fqdn = $MISP_URL#" config/config.cfg
sed -i "s#session_secret = \*\*Change_Me\*\*#session_secret = $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)#" config/config.cfg

sed -i "s#auth_enabled = False#auth_enabled = $AUTH_ENABLED#" config/config.cfg
sed -i "s#ssl_verify = True#ssl_verify = $SSL_VERIFY#" config/config.cfg
sed -i "s#session_cookie_secure = True#session_cookie_secure = $SECURE_COOKIE#" config/config.cfg
session_cookie_secure = True

sed -i "s#stdout = False#stdout = True" config/config.cfg

sed -i "s#\"url\": \"http://localhost\"#\"url\": \"$MISP_URL\"#" config/config.cfg
sed -i "s#\"zmq\": \"tcp://localhost:50000\"#\"zmq\": \"tcp://$ZMQ_URL:$ZMQ_PORT\"#" config/config.cfg

cat config/config.cfg

echo "Starting zmq"
./start_zmq.sh
# Setting up env for Flask
export FLASK_DEBUG=1
export FLASK_APP=server.py
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
echo "Starting server"
python3 -m flask run --host=0.0.0.0 --port=8001
