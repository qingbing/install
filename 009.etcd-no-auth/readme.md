# etcd 的安装

- [etcd 的安装](#etcd-的安装)
  - [1. 说明](#1-说明)
    - [1.1 参考链接](#11-参考链接)
  - [2. 命令](#2-命令)
    - [2.1 下载](#21-下载)
    - [2.2 清理下载目录](#22-清理下载目录)
    - [2.3 安装](#23-安装)
    - [2.4 卸载](#24-卸载)
  - [3. etcd 的简单使用](#3-etcd-的简单使用)

## 1. 说明

etcd 基于 SQLite 构建的轻量级、分布式关系数据库， 使用Go 编程实现，使用 Raft 算法来确保所有 SQLite 数据库实例的一致性。

### 1.1 参考链接

```text
https://blog.csdn.net/weixin_53041251/article/details/122992382
```

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

## 3. etcd 的简单使用

```bash
root@UTest1:~/# etcdctl put aaa testaa
OK
root@UTest1:~/# etcdctl get aaa
aaa
testaa
root@UTest1:~/# etcdctl get --prefix ""
aaa
testaa
root@UTest1:~/# etcdctl get --prefix "" --keys-only
```
