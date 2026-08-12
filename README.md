# Warfork Server

## 1. 简述

Warfork 原版服务器

**可用版本：**

| 游戏模式 | 镜像 tag      |
| -------- | ------------- |
| 死亡竞赛 | `dm-latest`   |
| 1v1 对决 | `dual-latest` |

## 2. 资源占用信息

### 2.1. 端口

| 端口号 | 协议 | 说明          |
| ------ | ---- | ------------- |
| 44400  | UDP  | 游戏联机端口  |
| 44444  | TCP  | HTTP 相关端口 |

## 3. 构建与运行

### 3.1. 构建并运行（Docker）

例：死亡竞赛模式：

```bash
docker build --target dm -t warfork:dm-temp . && \
    docker run --rm -it \
        -p 44400:44400/udp \
        -p 44444:44444/tcp \
        warfork:dm-temp
```

### 3.2. 运行服务器（Podman）

例：死亡竞赛模式（dm-latest）：

```bash
IMAGE=ghcr.io/hm-gamesrv/warfork:dm-latest

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name warfork-dm \
    --userns keep-id \
    --network pasta \
    -p 44400:44400/udp \
    -p 44444:44444/tcp \
    "$IMAGE"
```
