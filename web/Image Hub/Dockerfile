FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build1
WORKDIR /src

COPY src/dotnet .

RUN dotnet tool install --global dotnet-ef
RUN cd dotnet && /root/.dotnet/tools/dotnet-ef migrations add InitialCreate && /root/.dotnet/tools/dotnet-ef database update
RUN dotnet restore dotnet/dotnet.csproj
RUN dotnet publish dotnet/dotnet.csproj -c Release -o /publish

RUN cp ./dotnet/db.sqlite /publish

FROM golang:1.22-alpine AS build2

COPY ./service/readflag.go /build/
WORKDIR /build/
RUN go build -ldflags '-s -w' readflag.go

FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS final

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8

RUN apk add --update --no-cache bash icu-data-full icu-libs sqlite coreutils su-exec
COPY --from=build2 --chmod=755 /build/readflag /

COPY --from=build1 /publish /app
COPY ./service/docker-entrypoint.sh /app
COPY ./uploads /app/uploads
COPY ./service/Image.sql /tmp

RUN chown -R app:app /app && chmod +x /app/* && chown root:root readflag && chmod u+s readflag

WORKDIR /app

RUN sqlite3 db.sqlite < /tmp/Image.sql && rm /tmp/Image.sql

EXPOSE 5000
ENTRYPOINT ["/bin/bash","./docker-entrypoint.sh"]
