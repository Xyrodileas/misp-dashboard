FROM alpine:3.7

# Install core components
RUN apk add --no-cache sudo git wget python3 unzip libzmq
RUN python3 -m ensurepip && rm -r /usr/lib/python*/ensurepip && pip3 install --no-cache --upgrade pip setuptools wheel

RUN adduser -h /var/www -D www-data && addgroup sudo && addgroup www-data sudo
RUN adduser -D zmqs && addgroup zmqs www-data
RUN echo "www-data ALL=(zmqs) NOPASSWD:/bin/sh /var/www/misp-dashboard/start_zmq.sh" | tee /etc/sudoers.d/www-data
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setup www dir
WORKDIR /var/www
USER www-data

RUN git clone --branch master https://github.com/VVX7/misp-dashboard.git
WORKDIR /var/www/misp-dashboard

USER root
RUN apk add --no-cache --virtual /tmp/.build-deps build-base python3-dev libffi-dev libressl-dev zeromq-dev musl-dev \
    && pip3 install --no-cache-dir -U -r requirements.txt \
    && apk del /tmp/.build-deps

USER www-data
ADD bootstrap.sh /bootstrap.sh

USER root
RUN apk add --no-cache bash
USER www-data
RUN bash /bootstrap.sh

USER root
RUN apk del bash wget unzip git && rm -rf /var/cache/apk/*
USER www-data

#Run misp-dashboard
ADD run.sh /run.sh
RUN sudo chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
