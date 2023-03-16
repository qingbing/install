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

Etcd是CoreOS基于Raft协议开发的分布式key-value存储，可用于服务发现、共享配置以及一致性保障（如数据库选主、分布式锁等）。

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
