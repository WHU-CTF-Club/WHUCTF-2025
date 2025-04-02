FROM golang:1.22-alpine AS builder

COPY ./files/readflag.go /build/

WORKDIR /build/

RUN go build -ldflags '-s -w' readflag.go

FROM php:8.3.4-apache

COPY --from=builder --chmod=755 /build/readflag /
COPY --chmod=755 ./files/docker-entrypoint.sh /docker-entrypoint.sh

COPY --chown=www-data:www-data --chmod=777 ./src/html/ /var/www/html/

EXPOSE 80

ENTRYPOINT [ "/docker-entrypoint.sh" ]