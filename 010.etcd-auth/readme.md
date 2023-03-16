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

- 命令

```bash
# 集群状态
etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table endpoint status

# 健康状态
etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table endpoint status

# 成员列表
etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table member list

# 数据操作
etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 get aa
```

- 示例

```bash
root@UTest1:~# etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table endpoint status
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|          ENDPOINT          |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| http://192.168.242.10:2379 | 34ee5a9fc3295bdd |   3.5.6 |   20 kB |      true |      false |         2 |          5 |                  5 |        |
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
root@UTest1:~# etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table endpoint health
+----------------------------+--------+------------+-------+
|          ENDPOINT          | HEALTH |    TOOK    | ERROR |
+----------------------------+--------+------------+-------+
| http://192.168.242.10:2379 |   true | 2.040863ms |       |
+----------------------------+--------+------------+-------+
root@UTest1:~# etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 --write-out=table member list
+------------------+---------+------+----------------------------+----------------------------+------------+
|        ID        | STATUS  | NAME |         PEER ADDRS         |        CLIENT ADDRS        | IS LEARNER |
+------------------+---------+------+----------------------------+----------------------------+------------+
| 34ee5a9fc3295bdd | started | etcd | http://192.168.242.10:2380 | http://192.168.242.10:2379 |      false |
+------------------+---------+------+----------------------------+----------------------------+------------+
root@UTest1:~# etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints=http://192.168.242.10:2379 get aa
aa
test
```