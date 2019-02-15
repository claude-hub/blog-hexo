---
title: PostgreSQL配置文件详解
tags:
  - PostgreSQL
categories:
  - 数据库
author: Cloudy
date: 2019-02-15 14:37:01
---

1. 配置文件位置

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
   ```

   