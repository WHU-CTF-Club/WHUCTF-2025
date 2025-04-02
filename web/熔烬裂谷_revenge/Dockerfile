FROM golang:1.22-alpine AS builder

COPY ./files/readflag.go /build1/
COPY ./src/proxy /build2

WORKDIR /build1/

RUN go build -ldflags '-s -w' readflag.go

WORKDIR /build2

RUN go mod tidy && go build -ldflags '-s -w'

FROM php:8.3.4-apache

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && \
    apt install gosu  -y

COPY --from=builder --chmod=755 /build1/readflag /
COPY --from=builder --chmod=755 /build2/lava /app/app
COPY --chmod=755 ./files/docker-entrypoint.sh /docker-entrypoint.sh
COPY --chmod=755 ./files/curl /usr/local/bin

COPY --chown=www-data:www-data --chmod=777 ./src/html/ /var/www/html/

EXPOSE 8080

ENTRYPOINT [ "/docker-entrypoint.sh" ]
