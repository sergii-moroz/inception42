FROM alpine:3.19.4

RUN apk update && apk upgrade
RUN apk add --no-cache mariadb mariadb-client
RUN rm -f /var/cache/apk/*

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/main.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/main.sh

EXPOSE 3306

# USER mysql

ENTRYPOINT [ "main.sh" ]
