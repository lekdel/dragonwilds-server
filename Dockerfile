FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMDDIR=/opt/steamcmd
ENV SERVERDIR=/opt/dragonwilds

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      lib32gcc-s1 \
      lib32stdc++6 \
      libc6-i386 \
      tar \
      bash \
      procps \
      tini && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m steam

RUN mkdir -p ${STEAMCMDDIR} && \
    curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -xz -C ${STEAMCMDDIR}

RUN mkdir -p ${SERVERDIR} && \
    chown -R steam:steam /opt

WORKDIR /opt

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER steam

ENTRYPOINT ["/usr/bin/tini", "--", "/start.sh"]