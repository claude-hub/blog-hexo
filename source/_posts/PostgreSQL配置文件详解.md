---
title: PostgreSQL配置文件详解
tags:
  - PostgreSQL
categories:
  - 数据库
author: Cloudy
date: 2019-02-15 14:37:01
---

### 配置文件位置

```shell
postgres=# select name, setting from pg_settings where category='File Locations' ;
       name        |                setting                 
-------------------+----------------------------------------
 config_file       | /var/lib/pgsql/11/data/postgresql.conf
 data_directory    | /var/lib/pgsql/11/data
 external_pid_file | 
 hba_file          | /var/lib/pgsql/11/data/pg_hba.conf
 ident_file        | /var/lib/pgsql/11/data/pg_ident.conf
(5 rows)

//使用root权限查找
[root@api data]# find / -name pg_hba.conf
/var/lib/pgsql/11/data/pg_hba.conf
```

<!--more-->

### postgresql.conf

​	该文件包含一些通用设置，比如内存分配，新建database的默认存储位置，PostgreSQL服务器的IP地址，日志的位置以及许多其他设置。

### pg_hba.conf

​	客户端认证配置文件，允许哪些用户连接到哪个数据库，允许哪些IP或者哪个网段的IP连接到本服务器，以及指定连接时使用的身份验证模式

pg_hba.conf 客户端认证配置文件的认证类型包括:
- trust 本地可以使用 psql -U postgres 直接登录服务器； (生产环境勿用)

- peer 本地可以使用 `psql -h 127.0.0.1 -d postgres -U postgres `直接登录服务器; (peer使用发起端的操作系统名进行身份验证)

- password 使用 用户名密码(明文密码) 登录 ； (生产环境勿用)

- ident  

  ​	ident是Linux下PostgreSQL默认的local认证方式，凡是能正确登录服务器的操作系统用户（注：不是数据库用户）就能使用本用户映射的数据库用户不需密码登录数据库。	

- md5	md5是常用的密码认证方式，如果你不使用ident，最好使用md5。密码是以md5形式传送给数据库，较安全，且不需建立同名的操作系统用户

- reject	拒绝认证
  建议使用md5方式,不同用户相同密码加密的结果也不相同,因为会使用用户名和密码一同加密. 所以要注意:若已设密码的用户名称改变了,密码也会失效...

- Ident和peer模式适用于Linux，Unix和Mac,不适用于windwos

### pg_ident.conf

​	用户映射文件，若客户端使用ident类型认证,就需要这里的映射关系了.
比如，服务器上有名为user1的操作系统用户，同时数据库上也有同名的数据库用户，user1登录操作系统后可以直接输入psql，以user1数据库用户身份登录数据库且不需密码。
很多初学者都会遇到psql -U username登录数据库却出现“username ident 认证失败”的错误，明明数据库用户已经createuser。
原因就在于此，使用了ident认证方式，却没有同名的操作系统用户或没有相应的映射用户。
解决方案：1、在pg_ident.conf中添加映射用户；2、改变认证方式。

CentOS7安装了PostgreSQL10和pgadmin4后,pgadmin4始终登陆数据库提示用户认证失败,
就是因为Linux下PostgreSQL默认的local认证方式是ident,而pg_ident.cong用户映射文件里并没有任何映射用户,
所以可以修改认证方式为md5,即可使用密码成功登陆了.

参考文档

1. https://www.cnblogs.com/sztom/p/9534323.html