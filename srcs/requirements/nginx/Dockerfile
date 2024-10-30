FROM alpine:3.19

RUN apk update && apk upgrade
RUN apk add --no-cache nginx openssl
RUN rm -rf /var/cache/apk/*

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /etc/nginx/ssl
RUN openssl req \
	-x509 \
	-nodes \
	-days 365 \
	-newkey rsa:4096 \
	-out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=DE/ST=IDF/L=Heilbronn/O=42/OU=42/CN=smoroz.42.fr/UID=smoroz"

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
