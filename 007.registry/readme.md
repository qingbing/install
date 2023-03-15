# registry 的安装

- [registry 的安装](#registry-的安装)
  - [1. 说明](#1-说明)
    - [1.1 参考链接](#11-参考链接)
  - [2. 命令](#2-命令)
    - [2.1 下载](#21-下载)
    - [2.2 清理下载目录](#22-清理下载目录)
    - [2.3 安装](#23-安装)
    - [2.4 卸载](#24-卸载)
  - [3. 其他](#3-其他)
    - [3.1 证书生成](#31-证书生成)
    - [3.2 查看仓库](#32-查看仓库)
    - [3.3 推送镜像](#33-推送镜像)
    - [3.4 镜像推送脚本](#34-镜像推送脚本)

## 1. 说明

registry 是镜像仓库组件，还提供一些api操作接口，如果要本地镜像推送，需要配合containerd的ctr命令。

### 1.1 参考链接

```text
https://blog.saintic.com/blog/314.html
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

## 3. 其他

### 3.1 证书生成

```bash
openssl req -newkey rsa:4096 -nodes -sha256 -keyout custom.key -x509 -days 365 -out custom.crt

qingbing@qb:/code/certs$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout custom.key -x509 -days 36500 -out custom.crt
Generating a RSA private key
.....................................................................++++
........................................................................................................++++
writing new private key to 'custom.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:SiChuan
Locality Name (eg, city) []:ChengDu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:qiyezhu
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:registry.qiyezhu.net
Email Address []:780042175@qq.com
qingbing@qb:/code/certs$ ls
custom.crt  custom.key
```

### 3.2 查看仓库

```bash
root@UTest1:~/install/007.registry# curl -k https://registry.qiyezhu.net/v2/_catalog
{"repositories":[]}
```

### 3.3 推送镜像

```bash
# 本地导入镜像
ctr -n k8s.io i import nginx.tar
# 重新打tag
ctr -n k8s.io i tag --force docker.io/library/nginx:latest registry.qiyezhu.net/library/nginx:latest
# 推送
ctr -n k8s.io i push -k registry.qiyezhu.net/library/nginx:latest
```

### 3.4 镜像推送脚本

[镜像推送脚本](./image_push.sh)