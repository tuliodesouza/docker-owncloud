FROM ubuntu:14.04
MAINTAINER Tulio de Souza "me@tul.io"

ENV DEBIAN_FRONTEND noninteractive

ADD owncloud.list /etc/apt/sources.list.d/owncloud.list
ADD owncloud.list.key /tmp/owncloud.list.key
COPY owncloud.tar.bz2 /tmp/owncloud.tar.bz2

RUN apt-key add - < /tmp/owncloud.list.key && \
	apt-get update && \
	apt-get install -y nginx sqlite php5-gd php5-json php5-curl php5-intl php5-mcrypt php5-fpm php5-apcu php5-sqlite && \
	cd /tmp && \
	tar -xjf /tmp/owncloud.tar.bz2 && \
	mv /tmp/owncloud /var/www && \
	chown -R www-data:www-data /var/www && \
	mkdir -p /usr/local/nginx/conf && \
	cd /usr/local/nginx/conf && \
	openssl genrsa -out server.key 2048 && \
	openssl req -new -key server.key -out server.csr -subj '/CN=pi.tul.io/O=Tul.io Inc./C=UK' && \
	openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD owncloud.conf /etc/nginx/conf.d/owncloud.conf
ADD 30-owncloud.ini /etc/php5/fpm/conf.d/30-owncloud.ini

ADD run.sh /run.sh

EXPOSE 32003

CMD ["/run.sh"]
