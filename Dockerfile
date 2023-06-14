FROM ubuntu:22.04 AS prep

ENV BUILD_VERSION=v4.41-9787-rtm-2023.03.14

RUN cd /tmp \
    && apt-get update \
    && apt-get install -y wget gcc make \
    && wget https://jp.softether-download.com/files/softether/${BUILD_VERSION}-tree/Linux/SoftEther_VPN_Bridge/64bit_-_Intel_x64_or_AMD64/softether-vpnbridge-${BUILD_VERSION}-linux-x64-64bit.tar.gz \
    && tar -zxvf softether-vpnbridge-${BUILD_VERSION}-linux-x64-64bit.tar.gz \
    && rm softether-vpnbridge-${BUILD_VERSION}-linux-x64-64bit.tar.gz \
    && cd vpnbridge \
    && make

FROM ubuntu:22.04

COPY --from=prep /tmp/vpnbridge/vpnbridge /tmp/vpnbridge/vpncmd /tmp/vpnbridge/hamcore.se2 /usr/local/vpnbridge/

RUN apt-get update \
    && apt-get libssl libcrypto readline ncurses-l \
    && cd /usr/local/vpnbridge \
    && chmod 600 * \
    && chmod 700 vpncmd \
    && chmod 700 vpnbridge

EXPOSE 5555/tcp

# CMD ["/usr/local/vpnbridge/vpnbridge", "execsvc"]