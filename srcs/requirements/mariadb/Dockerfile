FROM alpine:3.19

RUN apk update && apk upgrade
RUN apk add --no-cache mariadb mariadb-client
RUN rm -f /var/cache/apk/*

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN mkdir /run/maria
RUN chown -R mysql:mysql /run/maria
RUN chmod -R 775 /run/maria

COPY ./tools/main.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/main.sh

EXPOSE 3306

USER mysql

ENTRYPOINT [ "main.sh" ]
