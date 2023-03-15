# rqlite 的安装

- [rqlite 的安装](#rqlite-的安装)
  - [1. 说明](#1-说明)
    - [1.1 参考链接](#11-参考链接)
  - [2. 命令](#2-命令)
    - [2.1 下载](#21-下载)
    - [2.2 清理下载目录](#22-清理下载目录)
    - [2.3 安装](#23-安装)
    - [2.4 卸载](#24-卸载)
  - [3. rqlite 的简单使用](#3-rqlite-的简单使用)

## 1. 说明

rqlite 基于 SQLite 构建的轻量级、分布式关系数据库， 使用Go 编程实现，使用 Raft 算法来确保所有 SQLite 数据库实例的一致性。

### 1.1 参考链接

```text
http://www.manongjc.com/detail/51-huleuoaitlduqoq.html
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

## 3. rqlite 的简单使用

通过 `rqlite -H {ip}` 进入rqlite客户端，其他命令可通过 `.help` 进行获取

```bash
root@UTest1:~/# rqlite -H 192.168.242.10
Welcome to the rqlite CLI. Enter ".help" for usage hints.
Version v7.13.2, commit 94b4d75412246637bb8818ea5c1f18c480f6418d, branch master
Connected to rqlited version v7.13.2
192.168.242.10:4001> .help
.backup <file>                      Write database backup to SQLite file
.consistency [none|weak|strong]     Show or set read consistency level
.dump <file>                        Dump the database in SQL text format to a file
.exit                               Exit this program
.expvar                             Show expvar (Go runtime) information for connected node
.help                               Show this message
.indexes                            Show names of all indexes
.nodes                              Show connection status of all nodes in cluster
.ready                              Show ready status for connected node
.remove <raft ID>                   Remove a node from the cluster
.restore <file>                     Restore the database from a SQLite database file or dump file
.schema                             Show CREATE statements for all tables
.status                             Show status and diagnostic information for connected node
.sysdump <file>                     Dump system diagnostics to a file for offline analysis
.tables                             List names of tables
192.168.242.10:4001> 

```