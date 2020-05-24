---
title: "Concept_notes"
date: 2020-04-17T17:56:22+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [基础概念](#基础概念)
* [安装](#安装)
* [工具](#工具)

<!-- vim-markdown-toc -->

## 基础概念

> [oracle数据库实例，用户，表空间的关系](https://blog.csdn.net/dong001687/article/details/73717547)
> [数据库逻辑设计之三大范式通俗理解，一看就懂，书上说的太晦涩](https://segmentfault.com/a/1190000013695030)
> 

## 安装

```bash
# 创建容器
docker run --privileged --name oracle11g -p 1521:1521 -v /home:/install jaspeen/oracle-11g

# 启动停止的oracle服务
docker container start oracle11g

# 交互式进入
[vagrant@localhost ~]$ docker exec -it oracle11g /bin/bash

# 切换
[root@7aa72f80c511 /]# su - oracle

# 登陆
[oracle@7aa72f80c511 ~]$ sqlplus / as sysdba
```

## 工具

> [Oracle SQL Developer 入门](https://www.oracle.com/ocom/groups/public/@otn/documents/webcontent/229078_zhs.htm)



