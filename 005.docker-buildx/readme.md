# docker-buildx 的安装

- [docker-buildx 的安装](#docker-buildx-的安装)
  - [1. 说明](#1-说明)
  - [2. 命令](#2-命令)
    - [2.1 下载](#21-下载)
    - [2.2 清理下载目录](#22-清理下载目录)
    - [2.3 安装](#23-安装)
    - [2.4 卸载](#24-卸载)

## 1. 说明

所有操作都在root权限下执行, 执行本命令的前提是需要自行安装好 docker

## 2. 命令

### 2.1 下载

```bash
make download
```

### 2.2 清理下载目录

```bash
make clean
```

### 2.3 安装

```bash
make install
```

### 2.4 卸载

```bash
make uninstall
```