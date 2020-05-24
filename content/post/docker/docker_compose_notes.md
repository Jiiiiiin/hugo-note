---
title: "Docker_compose_notes"
date: 2020-04-13T15:49:09+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [为什么需要Docker Compose](#为什么需要docker-compose)
* [Docker Compose](#docker-compose)
    * [docker-compose.yml](#docker-composeyml)
        * [Service](#service)
* [安装](#安装)
* [命令](#命令)
* [水平扩展](#水平扩展)
* [负载均衡](#负载均衡)
    * [haproxy](#haproxy)

<!-- vim-markdown-toc -->

## 为什么需要Docker Compose

+ 有些应用不仅仅是只启动一个容器，针对这种多容器搭建的应用，希望使用统一的流程来管理这一组容器的生命周期

![Text](http://qiniu.jiiiiiin.cn/jQgKPc.png)

+ docker compose就扮演了这样一个批处理的角色

    ![Text](http://qiniu.jiiiiiin.cn/lSn3tL.png)


## Docker Compose

+ Docker Compose是一个具
+ 这个工具可以通过一个yml文件定义多容器的docker应用
+ 通过一条命令就可以根据yml文件的定义去创建或者管理这多个容器

### docker-compose.yml

+ 固定文件名

    - 具有版本的概念: [Compose file versions and upgrading](https://docs.docker.com/compose/compose-file/compose-versioning/)
    - version2定义的内容，只能全部运行在单机，而version3可以支持多机
    - 即version3开始支持将同一个docker-compose定义的不同容器跑在不同的主机
+ 核心概念
    ![Text](http://qiniu.jiiiiiin.cn/olp6Gu.png)
    ![Text](http://qiniu.jiiiiiin.cn/UHXQ4H.png)
    ![Text](http://qiniu.jiiiiiin.cn/mfyaUp.png)
#### Service

+ 例子

```yml
version: '3'

services:

  wordpress:
    image: wordpress
    ports:
      - 8080:80
    depends_on:
      - mysql
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_PASSWORD: root
    networks:
      - my-bridge

  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - my-bridge

volumes:
  mysql-data:

networks:
  my-bridge:
    driver: bridge
```

+ 使用自定义的dockerfile构建images示例

```bash
version: "3"

services:

  redis:
    image: redis

  web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8080:5000
    environment:
      REDIS_HOST: redis
```

## 安装

> [Install Docker Compose](https://docs.docker.com/compose/install/)

## 命令

```bash
# 查看进程服务

docker-compose ps

#
预先构建docker-compose.yml中需要build的镜像，这样在执行up的时候就可以直接使用或者说跳过这个构建的过程，速度就会快一些
#
另外如果docker-compose.yml本身配置发生了改变（根本地build镜像相关的），也需要重新执行当前的命令

docker-compose build

# 运行

# 加上-d意味后台执行，不加-d可以看到启动log，方便调试
docker-compose up [-d]


# 查看docker-compose所定义的容器和其对应使用的images

docker-compose images

# 进入容器

#
如下面进入对应服务名的容器，使用bash指令，注意这里的服务名是在docker-compose.yml文件中声明的服务标示或者说名称
docker-compose exec SERVICE_NAME bash

# 删除容器

docker-compose down

```

## 水平扩展


+ 查看命令

```bash
docker-compose -h

scale              Set number of containers for a service

docker-compose up -h

Usage: up [options] [--scale SERVICE=NUM...] [SERVICE...]

--scale SERVICE=NUM        Scale SERVICE to NUM instances. Overrides the
                               `scale` setting in the Compose file if present.

# 即我们可以在启动的时候设置对应的SERVICE（这里是compose
file中的服务名）伸缩对应数量的实例

[vagrant@localhost flask-redis]$ docker-compose up --scale web=3 -d
Starting flask-redis_redis_1 ... done
Starting flask-redis_web_1   ... done
Starting flask-redis_web_2   ... done
Starting flask-redis_web_3   ... done
[vagrant@localhost flask-redis]$ docker-compose ps
       Name                      Command               State    Ports
-----------------------------------------------------------------------
flask-redis_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp
flask-redis_web_1     python app.py                    Up      5000/tcp
flask-redis_web_2     python app.py                    Up      5000/tcp
flask-redis_web_3     python app.py                    Up      5000/tcp

# 注意上面的5000端口是对应3个容器中的5000端口，并没有映射到宿主机中
```

![Text](http://qiniu.jiiiiiin.cn/fdQDoA.png)

目前的一个情况类似上图；

+ 如果我们在拉伸之后的应用群组前面加一个LB来承接请求，之后负载到各个节点，那么就实现了一个简单的应用集群




## 负载均衡

### haproxy

![Text](http://qiniu.jiiiiiin.cn/slffdd.png)

如上配置之后，就在应用前使用haproxy插件完成了一个LB集群；

```bash
[vagrant@localhost lb-scale]$ for i in `seq 10`; do curl localhost; done
Hello Container World! I have been seen 8 times and my hostname is 41d8d79b0aad.
Hello Container World! I have been seen 9 times and my hostname is 1aac373bb6f5.
Hello Container World! I have been seen 10 times and my hostname is 1a647162932a.
Hello Container World! I have been seen 11 times and my hostname is 41d8d79b0aad.
Hello Container World! I have been seen 12 times and my hostname is 1aac373bb6f5.
Hello Container World! I have been seen 13 times and my hostname is 1a647162932a.
Hello Container World! I have been seen 14 times and my hostname is 41d8d79b0aad.
Hello Container World! I have been seen 15 times and my hostname is 1aac373bb6f5.
Hello Container World! I have been seen 16 times and my hostname is 1a647162932a.
```





