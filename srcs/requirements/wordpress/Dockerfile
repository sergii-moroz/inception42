FROM alpine:3.19.4

RUN apk update && apk upgrade
RUN apk add --no-cache \
	php82 \
	php82-fpm \
	php82-phar \
	php82-mysqli \
	php82-iconv \
	mariadb-client \
	openssl

RUN rm -rf /var/cache/apk/*

COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf

RUN mkdir -p /run/php/ && \
	touch /run/php/php8.2-fpm.pid

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./tools/wp_setup.sh /tmp/wp_setup.sh
RUN chmod +x /tmp/wp_setup.sh

EXPOSE 9000

CMD [ "ash", "/tmp/wp_setup.sh" ]
