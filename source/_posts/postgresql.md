title: PostgreSQL
tags:
  - PostgreSQL
categories:
  - 数据库
author: Cloudy
date: 2019-02-11 17:13:00

---

###  Centos 7安装PostgreSQL

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
   psql postgres //登录数据库，执行后提示符变为 'postgres=#' psql -U postgres -p 8998
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

### Docker安装PostgreSQL

```shell
docker pull postgres
docker run --name postgres01 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d --restart=always postgres
```

### 备份与恢复

```shell
pg_basebackup -F p -D /var/lib/pgsql/11/backups  -v -h 40.73.35.55 -p 8998 -U postgres -W
Password:

pg_basebackup -R -D /var/lib/pgsql/11/data  -h 40.73.35.55 -p 8998 -U postgres -w
-R 选项可以自动生成recovery.conf文件

pg_basebackup -h 40.73.35.55 -p 8998  -U postgres -w -D /var/lib/pgsql/11/data -X stream -P
```

[postgresql 高可用集群搭建资料](https://www.jianshu.com/p/77f07af6ca4b)

[PostgresSQL HA高可用架构实战](http://www.uml.org.cn/zjjs/201605031.asp)

HA 方案

 	1. 共享存储
 	2. drbd
 	3. 基于流复制

#### 流复制

 - 异步流复制

   ​	异步流复制的中心思想是：主库上提交事务时不需要等待备库接收WAL日志流并写入到备库WAL日志文件时便返回成功，因此异步流复制的TPS会相对同步流复制要高，延迟更低。

   参考博客

    	1. https://www.cnblogs.com/sunshine-long/p/9059695.html
    	2. https://lihaoquan.me/2018/9/29/postgresql-master-slave-ha.html

   验证是否部署成功

    ~~~shell
   su - postgres
   psql -U postgres -p 8998
   //主服务器
   postgres=# select pg_is_in_recovery();
   pg_is_in_recovery
   -------------------
   f //f表示主
   (1 row)
   //备服务器
   postgres=# select pg_is_in_recovery();
   pg_is_in_recovery
   -------------------
   t //t表示备
   (1 row)
   
   //主服务器，async表示异步流复制
   postgres=# select client_addr,application_name,sync_state from pg_stat_replication;
   
   client_addr  | sync_state 
   ---------------+------------
   139.219.6.177 | async
   (1 row)
    ~~~

- 同步流复制

  事务同步

  只需修改master

  ~~~shell
  vim postgresql.conf
  synchronous_standby_names = '*'
  synchronous_commit = on
  
  postgres=# select client_addr,application_name,sync_state from pg_stat_replication;
   client_addr  | application_name | sync_state 
  ---------------+------------------+------------
   139.219.6.177 | walreceiver      | sync
  (1 row)
  ~~~

  

  