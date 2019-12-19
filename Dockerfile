FROM ubuntu:xenial

# Install core components
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
RUN apt-get install -y sudo git python3 python3-virtualenv apt-utils wget redis-server
RUN adduser www-data sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Setup www dir
WORKDIR /var/www
RUN chown www-data:www-data /var/www
USER www-data

#Start installing dashboard
RUN git clone https://github.com/MISP/misp-dashboard.git
WORKDIR /var/www/misp-dashboard
RUN ./install_dependencies.sh

#Run misp-dashboard
ADD run.sh /run.sh
RUN sudo chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
