# =================
# Download
# =================
FROM debian:trixie-slim AS download

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/depot-downloader \
    && wget -qO /opt/depot-downloader/DepotDownloader-linux-x64.zip \
    https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip \
    && unzip /opt/depot-downloader/DepotDownloader-linux-x64.zip -d /opt/depot-downloader \
    && rm -f /depot-downloader/DepotDownloader-linux-x64.zip

# 服务端文件内容
RUN /opt/depot-downloader/DepotDownloader -os linux -validate -dir /download -app 1136510 -branch beta -depot 1136518 -manifest 6220042012545894201
# Steam 库
RUN /opt/depot-downloader/DepotDownloader -os linux -validate -dir /download -app 90 -depot 1006 -manifest 6403079453713498174

# ===================
# Install
# ===================
FROM download AS install

COPY --from=download --chown=1000:1000 ["/download/linux64/steamclient.so", "/app/bin/linux64/steamclient.so"]
COPY --from=download --chown=1000:1000 ["/download", "/app"]
COPY --chown=1000:1000 ["./patch/base", "/app"]
RUN chmod +x /app/wf_steam.x86_64 \
    && chmod +x /app/wf_server.x86_64

# ===================
# 基座镜像
# ===================
FROM debian:trixie-slim AS base

ENV TZ=Asia/Shanghai

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libstdc++6 \
    libcurl4 \
    zlib1g \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 gamesrv \
    && useradd -u 1000 -g gamesrv -m -s /bin/bash gamesrv
RUN mkdir -p /app && chown 1000:1000 /app

COPY --from=install --chown=1000:1000 ["/app", "/app"]

EXPOSE 44400/udp 44444/tcp

WORKDIR /app
USER 1000:1000

# ===================
# 分支：双人对决
# ===================
FROM base AS dual

COPY --chown=1000:1000 ["./patch/dual/", "/app"]

CMD ["bash", "/app/start-server.sh"]

# ===================
# 分支：死亡竞赛
# ===================
FROM base AS dm

COPY --chown=1000:1000 ["./patch/dm/", "/app"]

CMD ["bash", "/app/start-server.sh"]
