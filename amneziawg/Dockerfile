FROM ubuntu:24.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates git make curl unzip
    
ENV PATH="$PATH:/usr/local/go/bin"

RUN curl -sL \
    -O https://go.dev/dl/go1.26.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.26.0.linux-amd64.tar.gz \
    && rm -f go1.26.0.linux-amd64.tar.gz
    
RUN curl -sL \
    -O https://github.com/amnezia-vpn/amneziawg-tools/releases/download/v1.0.20250903/ubuntu-22.04-amneziawg-tools.zip \
    && unzip ubuntu-22.04-amneziawg-tools.zip ubuntu-22.04-amneziawg-tools/awg \
    && mv ubuntu-22.04-amneziawg-tools/awg /usr/local/sbin/ \
    && chmod +x /usr/local/sbin/awg

RUN git clone https://github.com/amnezia-vpn/amneziawg-go \
    && cd amneziawg-go \
    && make \
    && mv amneziawg-go /usr/local/sbin/

# ===============
FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates curl iproute2 iputils-ping dnsutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder \
    /usr/local/sbin/amneziawg-go \
    /usr/local/sbin/awg \
    /usr/local/sbin/

COPY ./run-awg.sh /

CMD ["/usr/bin/bash", "/run-awg.sh"]