FROM ubuntu:xenial

# Install core components
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
RUN apt-get install -y sudo git python3 python3-virtualenv apt-utils wget redis-server
RUN wget https://bootstrap.pypa.io/get-pip.py; python3 get-pip.py

RUN adduser www-data sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers



# Setup www dir
WORKDIR /var/www
RUN chown www-data:www-data /var/www
USER www-data

#Start installing dashboard
RUN git clone --branch master https://github.com/VVX7/misp-dashboard.git
WORKDIR /var/www/misp-dashboard

RUN export VIRTUAL_ENV=False; sudo ./install_dependencies.sh


#Run misp-dashboard
ADD run.sh /run.sh
RUN sudo chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
