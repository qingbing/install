# go 的安装

- [go 的安装](#go-的安装)
  - [1. 说明](#1-说明)
  - [2. 命令](#2-命令)
    - [2.1 下载](#21-下载)
    - [2.2 清理下载目录](#22-清理下载目录)
    - [2.3 安装](#23-安装)
    - [2.4 卸载](#24-卸载)
    - [2.5 设置常用用户](#25-设置常用用户)

## 1. 说明

- 参考链接: https://zhuanlan.zhihu.com/p/492149414

所有操作都在root权限下执行

## 2. 命令

### 2.1 下载

jdk官网: https://www.oracle.com/， 下载需要登录token，需要自行注册下载并存放在buildTemp目录下，文件保存为: jdk.tar.gz

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

### 2.5 设置常用用户

```bash
make user USER=qingbing
```
