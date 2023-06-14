FROM alpine:latest AS prep

LABEL maintainer="Yuki Masaki <woodenhoe@gmail.com>"

ENV BUILD_VERSION=v4.38-9760-rtm

RUN cd /tmp \
    && wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/${BUILD_VERSION}/softether-src-${BUILD_VERSION}.tar.gz \
    && mkdir -p /usr/local/src \
    && tar -x -C /usr/local/src/ -f softether-src-${BUILD_VERSION}.tar.gz \
    && rm softether-src-${BUILD_VERSION}.tar.gz

FROM alpine:latest AS build

COPY --from=prep /usr/local/src /usr/local/src

RUN apk add -U --no-cache build-base ncurses-dev openssl-dev readline-dev zip zlib-dev \
    && cd /usr/local/src/* \
    && ./configure \
    && make \
    && make install

FROM alpine:latest

COPY --from=build /usr/vpnbridge/ /usr/vpnbridge/

RUN apk add -U --no-cache ncurses readline

EXPOSE 5555/tcp

CMD ["/usr/vpnbridge/vpnbridge", "execsvc"]