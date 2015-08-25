FROM ubuntu:15.04
MAINTAINER Tulio de Souza "me@tul.io"

ENV DEBIAN_FRONTEND noninteractive

ADD run.sh /run.sh

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y nginx sqlite bzip2 php5-gd php5-json git php5-curl php5-intl php5-mcrypt php5-fpm php5-apcu php5-sqlite wget && \
	cd /tmp && \
	wget https://download.owncloud.org/community/owncloud-8.1.1.tar.bz2 && \
	tar -xjf /tmp/owncloud-8.1.1.tar.bz2 && \
	mv /tmp/owncloud /var/www/. && \
	git clone https://github.com/owncloud/notes.git /var/www/apps/notes && \
	chown -R www-data:www-data /var/www && \
	mkdir -p /usr/local/nginx/conf && \
	cd /usr/local/nginx/conf && \
	openssl genrsa -out server.key 2048 && \
	openssl req -new -key server.key -out server.csr -subj '/CN=pi.tul.io/O=Tul.io Inc./C=UK' && \
	openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	chmod u+x /run.sh

ADD owncloud.conf /etc/nginx/conf.d/owncloud.conf
ADD 30-owncloud.ini /etc/php5/fpm/conf.d/30-owncloud.ini

Volume /var/www/apps
Volume /var/log

EXPOSE 443

CMD ["/run.sh"]
