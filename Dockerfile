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
RUN git clone https://github.com/VVX7/misp-dashboard.git
WORKDIR /var/www/misp-dashboard
RUN export VIRTUAL_ENV=1
RUN ./install_dependencies.sh
RUN pip3 install -U -r requirements.txt

#Run misp-dashboard
ADD run.sh /run.sh
RUN sudo chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
