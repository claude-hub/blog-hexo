title: Docker
tags:
  - Docker
categories:
  - 服务器
author: Cloudy
date: 2019-02-11 17:12:01
---
### 1. Centos7安装docker

<!--more-->

```shell
yum install docker
systemctl start docker
systemctl enable docker //开机启动
systemctl stop docker
[root@rd-test /]# docker version
Client:
 Version:         1.13.1
 API version:     1.26
 Package version: docker-1.13.1-88.git07f3374.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      07f3374/1.13.1
 Built:           Fri Dec  7 16:13:51 2018
 OS/Arch:         linux/amd64

Server:
 Version:         1.13.1
 API version:     1.26 (minimum version 1.12)
 Package version: docker-1.13.1-88.git07f3374.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      07f3374/1.13.1
 Built:           Fri Dec  7 16:13:51 2018
 OS/Arch:         linux/amd64
 Experimental:    false
```

