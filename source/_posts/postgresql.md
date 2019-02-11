title: PostgreSQL
tags:

  - PostgreSQL
categories:
  - 数据库
author: Cloudy
date: 2019-02-11 17:13:00
---

### 1. Centos 7安装PostgreSQL

[官方安装说明](https://www.postgresql.org/download/linux/redhat/) 

参考博客[Centos 7 安装 PostgreSQL](https://www.cnblogs.com/stulzq/p/7766409.html)

<!--more-->

1. 安装存储库

   ```shell
   yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
   ```

2. 安装客户端

   ```shell
   yum install postgresql11
   ```

3. 安装服务端

   ```shell
   yum install postgresql11-server
   ```

4. 验证是否安装成功

   ```shell
   rpm -aq| grep postgres
   ```

   ![成功输出](/images/TIM截图20190211101512.png)

5. 初始化数据库

   ```shell
   /usr/pgsql-11/bin/postgresql-11-setup initdb
   ```

6. 开机自动启动

   ```shell
   systemctl enable postgresql-11
   systemctl start postgresql-11
   ```

7. 修改密码
   postgresql安装完成后，会在系统中创建默认用户postgres，没有默认密码。

   登录

   ```shell
   su postgres //切换用户，执行后提示符会变为 '-bash-4.2$'
   psql postgres //登录数据库，执行后提示符变为 'postgres=#'
   ```

   创建密码

   ```shell
   postgres=# \password postgres  #给postgres用户设置密码
   Enter new password:             #输入用户密码
   Enter it again:                 #再次输入密码
   \q  //退出数据库
   ```

8. 开启远程访问

   ```shell
   vim /var/lib/pgsql/11/data/postgresql.conf
   修改#listen_addresses = 'localhost'  为  listen_addresses = '*'
   当然，此处‘*’也可以改为任何你想开放的服务器IP
   ```

9. 信任连接

   ```shell
   vim /var/lib/pgsql/11/data/pg_hba.conf
   # IPv4 local connections:
   host    all             all             127.0.0.1/32            ident
   允许所有ip通过密码连接
   host    all             all             0.0.0.0/0               md5
   ```

10. 配置防火墙

    ```shell
      firewall-cmd --permanent --add-port=5432/tcp  
      firewall-cmd --permanent --add-port=80/tcp  
      firewall-cmd --reload  
    ```

      最后确保端口5432可以在外部访问到，比如，需要开通阿里云服务器暴露的端口。

11. 重启服务

    ```shell
    systemctl restart postgresql-11
    ```

12. 使用navicat连接数据库

### 2. Docker安装PostgreSQL

```shell
docker pull postgres
docker run --name postgres01 -e POSTGRES_PASSWORD=postgres -p 54321:5432 -d --restart=always postgres
```

### 3. 备份与恢复