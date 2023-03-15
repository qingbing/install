# cfssl在github源码中无法找到arm64的文件下载，只能手动编译

## 1. 说明

## 1.1 参考链接

- 交叉编译
  - https://blog.csdn.net/inthat/article/details/120327137
- 编译参考
  - https://blog.csdn.net/weixin_43965030/article/details/111033249
- github源码地址
  - https://github.com/cloudflare/cfssl/releases/

### 1.2 前提

需要本机安装go语言。

```bash
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.io,direct
```

## 2. 安装

- 步骤命令

```bash
wget https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.0.tar.gz
tar -xzvf v1.6.0.tar.gz
cd cfssl-1.6.0/
go mod vendor
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssl cmd/cfssl/cfssl.go
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssljson cmd/cfssljson/cfssljson.go
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssl-certinfo cmd/cfssl-certinfo/cfssl-certinfo.go
file bin/*
```

- 步骤日志

```bash
qingbing@qb:/code/go/src$ wget https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.0.tar.gz
--2023-03-15 17:35:11--  https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.0.tar.gz
正在连接 192.168.242.1:10809... 已连接。
已发出 Proxy 请求，正在等待回应... 302 Found
位置：https://codeload.github.com/cloudflare/cfssl/tar.gz/refs/tags/v1.6.0 [跟随至新的 URL]
--2023-03-15 17:35:12--  https://codeload.github.com/cloudflare/cfssl/tar.gz/refs/tags/v1.6.0
正在连接 192.168.242.1:10809... 已连接。
已发出 Proxy 请求，正在等待回应... 200 OK
长度： 未指定 [application/x-gzip]
正在保存至: “v1.6.0.tar.gz”

v1.6.0.tar.gz                                          [                                              <=>                                                               ]   7.08M   216KB/s    用时 39s   

2023-03-15 17:35:52 (186 KB/s) - “v1.6.0.tar.gz” 已保存 [7428162]

qingbing@qb:/code/go/src/cfssl-1.6.0$ wget https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.0.tar.gz
qingbing@qb:/code/go/src$ cd cfssl-1.6.0/
qingbing@qb:/code/go/src/cfssl-1.6.0$ go get github.com/GeertJohan/go.rice/rice
go: downloading github.com/GeertJohan/go.rice v1.0.3
go: downloading github.com/GeertJohan/go.incremental v1.0.0
go: downloading github.com/akavel/rsrc v0.8.0
go: downloading github.com/daaku/go.zipexe v1.0.2
go: downloading github.com/jessevdk/go-flags v1.4.0
go: downloading github.com/nkovacs/streamquote v1.0.0
go: downloading github.com/valyala/fasttemplate v1.0.1
go: downloading github.com/valyala/bytebufferpool v1.0.0
go: upgraded github.com/GeertJohan/go.rice v1.0.0 => v1.0.3
qingbing@qb:/code/go/src/cfssl-1.6.0$ go mod vendor
go: downloading bitbucket.org/liamstask/goose v0.0.0-20150115234039-8488cc47d90c
go: downloading golang.org/x/lint v0.0.0-20190930215403-16217165b5de
go: downloading golang.org/x/crypto v0.0.0-20201124201722-c8d3bf9c5392
go: downloading github.com/jmoiron/sqlx v1.2.0
go: downloading github.com/google/certificate-transparency-go v1.0.21
go: downloading github.com/kisielk/sqlstruct v0.0.0-20150923205031-648daed35d49
go: downloading github.com/stretchr/testify v1.4.0
go: downloading github.com/go-sql-driver/mysql v1.4.0
go: downloading github.com/lib/pq v1.3.0
go: downloading github.com/mattn/go-sqlite3 v1.10.0
go: downloading github.com/zmap/zlint/v3 v3.0.0
go: downloading github.com/cloudflare/redoctober v0.0.0-20171127175943-746a508df14c
go: downloading github.com/jmhodges/clock v0.0.0-20160418191101-880ee4c33548
go: downloading github.com/prometheus/client_golang v1.9.0
go: downloading github.com/zmap/zcrypto v0.0.0-20201128221613-3719af1573cf
go: downloading golang.org/x/net v0.0.0-20201110031124-69a78807bb2b
go: downloading github.com/cloudflare/backoff v0.0.0-20161212185259-647f3cdfc87a
go: downloading github.com/kisom/goutils v1.1.0
go: downloading google.golang.org/appengine v1.6.6
go: downloading github.com/golang/protobuf v1.4.3
go: downloading github.com/prometheus/common v0.15.0
go: downloading github.com/prometheus/procfs v0.2.0
go: downloading golang.org/x/sys v0.0.0-20201214210602-f9fddec55a1e
go: downloading golang.org/x/tools v0.0.0-20200103221440-774c71fcf114
go: downloading github.com/kylelemons/go-gypsy v0.0.0-20160905020020-08cad365cd28
go: downloading github.com/ziutek/mymysql v1.5.4
go: downloading gopkg.in/yaml.v2 v2.3.0
go: downloading github.com/getsentry/raven-go v0.0.0-20180121060056-563b81fc02b7
go: downloading github.com/weppos/publicsuffix-go v0.13.0
go: downloading google.golang.org/protobuf v1.23.0
go: downloading golang.org/x/text v0.3.4
go: downloading github.com/certifi/gocertifi v0.0.0-20180118203423-deb3ae2ef261
qingbing@qb:/code/go/src/cfssl-1.6.0$ CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssl cmd/cfssl/cfssl.go
qingbing@qb:/code/go/src/cfssl-1.6.0$ CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssljson cmd/cfssljson/cfssljson.go
qingbing@qb:/code/go/src/cfssl-1.6.0$ CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -ldflags '-extldflags "-static"' -o bin/cfssl-certinfo cmd/cfssl-certinfo/cfssl-certinfo.go
qingbing@qb:/code/go/src/cfssl-1.6.0$ file bin/*
bin/cfssl:          ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=bfcKoH85B32pE76mtarA/NksgsZ3QyZSH8svIL-VY/GUsepU8qcipa1nL1Z8CR/inX2j8TAjvSeTEXZAqh3, with debug_info, not stripped
bin/cfssl-certinfo: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=YdtRLWBGF4NwtpV9Kcc5/1NywMz1rpfUb3fvh81-v/n9GPYoXXDLNRMhcsL4hj/h2btPRSQ8yHASNkl0-dR, with debug_info, not stripped
bin/cfssljson:      ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=yd54kOtV3iotnQIbc0Nt/bTNpWQGlini0UzrXN0Yx/L8D99q3LGjIpnuEEXSOF/dg8wcSH6P3MkWgJrVr4n, with debug_info, not stripped
```