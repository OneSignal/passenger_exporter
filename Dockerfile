FROM golang:1-stretch as build-passenger-exporter

RUN apt-get update \
    && apt-get install -y build-essential gcc make wget

RUN wget -q https://github.com/prometheus/promu/releases/download/v0.12.0/promu-0.12.0.linux-amd64.tar.gz -O promu.tar.gz \
    && tar --strip-components=1 -xzf promu.tar.gz \
    && cp ./promu /usr/local/bin

RUN mkdir -p /build/
WORKDIR /build/
COPY ./ ./

RUN make


FROM debian:stretch-slim

RUN apt-get update \
    && apt-get install -y apt-transport-https gnupg \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7 \
    && echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main' > /etc/apt/sources.list.d/passenger.list \
    && apt-get update \
    && apt-get install  -o Dpkg::Options::=--force-confdef -yq --no-install-recommends passenger=1:6.0.8-1~stretch1 libxml2-utils

RUN mkdir -p /app/
WORKDIR /app/

COPY --from=build-passenger-exporter /build/passenger_exporter_nginx /app/

ENTRYPOINT [ "/app/passenger_exporter_nginx" ]
