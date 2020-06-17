FROM ubuntu:16.04

MAINTAINER Alexander Mentyu <notuxius@gmail.com>

ENV MYSQLTMPROOT toor

# RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN echo mysql-server mysql-server/root_password password $MYSQLTMPROOT | debconf-set-selections;\
  echo mysql-server mysql-server/root_password_again password $MYSQLTMPROOT | debconf-set-selections;\
  apt-get update && apt-get install -y mysql-server mysql-client libmysqlclient-dev \
  nginx php php-common php-gd php-curl php-mail php-mail-mime php-pear php-db php-mysqlnd \
  freeradius freeradius-mysql freeradius-utils\
  wget unzip vim && \
  pear install DB && \
  apt-get clean && \
  # dpkg-reconfigure --frontend noninteractive tzdata && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cpan	

ENV RADIUS_DB_PWD radpass
ENV CLIENT_NET "0.0.0.0/0"
ENV CLIENT_SECRET testing123


RUN wget https://github.com/lirantal/daloradius/archive/master.zip && \
  unzip *.zip && \
  mv daloradius-master /var/www/daloradius && \
  chown -R www-data:www-data /var/www/daloradius && \
  chmod 644 /var/www/daloradius/library/daloradius.conf.php && \
  rm /etc/nginx/sites-enabled/default

#	cp -R /var/www/daloradius/contrib/chilli/portal2/hotspotlogin /var/www/daloradius

COPY init.sh /	
COPY run.sh /	
COPY test.sh /
RUN chmod +x /init.sh && chmod +x /run.sh && chmod +x /test.sh

COPY etc/nginx/radius.conf /etc/nginx/sites-enabled/

COPY accounting_packets/ /home


EXPOSE 1812 1813 80

ENTRYPOINT ["/run.sh"]

