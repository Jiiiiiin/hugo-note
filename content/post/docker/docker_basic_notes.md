---
title: "Docker_basic_notes"
date: 2020-03-05T13:30:35+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
* [Docker Engine](#docker-engine)
    * [底层技术支持](#底层技术支持)
    * [image](#image)
        * [通过Dockerfile 构建一个image](#通过dockerfile-构建一个image)
    * [Dockerfile 语法](#dockerfile-语法)
        * [FROM](#from)
        * [LABEL](#label)
        * [Shell 格式和 Exec 格式](#shell-格式和-exec-格式)
        * [RUN](#run)
        * [CMD](#cmd)
        * [ENTRYPOINT](#entrypoint)
        * [WORKDIR](#workdir)
        * [ADD and COPY](#add-and-copy)
        * [ENV](#env)
        * [VOLUME](#volume)
        * [EXPOSE](#expose)
* [Container](#container)
* [其他](#其他)
    * [发布 image](#发布-image)

<!-- vim-markdown-toc -->


## 常用命令

```bash
 启动 dockerd: sudo service docker start 

# image

拉取 IMAGE：docker pull IMAGE_NAME[:VERSION]
查询已经安装的 image：docker image ls

查看 image 的分层：docker history 5085d042f5bf
使用 image 的 id；

运行 image：docker run jiiiiiin/hello-wold

 删除 image：docker image rm IMAGE_ID

push 一个 image 到 docker hub：docker push xiaopeng163/hello-world:latest

# Container

交互式运行一个 image：docker run -it centos /bin/bash
这种方式需要注意 image 的制作是以CMD 还是其他方式制定运行的“ 初始化脚本 ”

后台运行一个容器：docker run -d IMAGE_ID

运行一个容器，制定名称（需要唯一）：docker run --name=NAME IMAGE_ID

查看运行中的 Container：docker container ls

查看所有的容器：docker container ls -a
包括当前正在运行和已经结束的；

列出所有 Container ID：docker container ls -aq
输出结果等于：docker container ls -a | awk {'print$1'} | tail -n +2

删除所有 Container ：docker rm $(docker container ls -aq)
删除容器的前提是容器必须是推出状态；

对 Container 列表进行过滤：docker container ls -f "status=exited"
docker container ls -f "status=exited" -q

进入正在运行的容器中去查看：docker exec -it CONTAINER_ID /bin/bash
将 CONTAINER_ID 替换成运行中容器的 id；

停止一个运行中的容器：docker [container] stop CONTAINER_ID 

启动一个停止的容器：docker [container] start CONTAINER_ID

查看一个容器的详细信息：docker inspect CONTAINER_ID
可以查看 image、网络等信息；

查看容器日志输出：docker [container] logs CONTAINER_ID

```


## Docker Engine

Docker提供了一个开发 ，打包，运行app的平台

把app和底层infrastructure隔离开来

![Text](http://qiniu.jiiiiiin.cn/kTVB8H.png)

![Text](http://qiniu.jiiiiiin.cn/ZK1Ox0.png)

+ 后台进程（ dockerd ）
+ REST API Server 
+ CLI 接口（docker）
![Text](http://qiniu.jiiiiiin.cn/jDddFH.png)

### 底层技术支持
+ Namespaces ：做隔离pid， net， ipc， mnt， uts
+ Control groups ：做资源限制
+ Union file systems ： Container和image的分层

### image

+ 文件和meta data的集合（ root filesystem ）
+ 分层的，并且每一层都可以添加改变
+ 删除文件，成为一个新的image
+ 不同的image可以共享相同的layer
+ Image本身是read-only的

![Text](http://qiniu.jiiiiiin.cn/umsNf2.png)
![Text](http://qiniu.jiiiiiin.cn/kouHFt.png)
#### 通过Dockerfile 构建一个image

![Text](http://qiniu.jiiiiiin.cn/m4crsS.png)

```Dockerfile
FROM scratch
ADD hello /
CMD ["/hello"]
```

上面就是一个最简单的 Dockerfile；

```bash
# -t[ag] 命名构建的 image 的 NAME，"." 表示使用当前目录下的 Dockerfile
[vagrant@localhost hello-world]$ docker build -t jiiiiiin/hello-wold .
Sending build context to Docker daemon  847.9kB
Step 1/3 : FROM scratch
 --->
Step 2/3 : ADD hello /
 ---> f92920ee2484
Step 3/3 : CMD ["/hello"]
 ---> Running in 9bc614fd39e1
Removing intermediate container 9bc614fd39e1
 ---> 5085d042f5bf
Successfully built 5085d042f5bf
Successfully tagged jiiiiiin/hello-wold:latest
```
执行构建；

运行这个 image 会共享宿主机（centos）的 linux 内核来运行；


### Dockerfile 语法

> [Dockerfile 语法](https://coding.imooc.com/lesson/189.html#mid=11618)

另外可以上官网看看一些官方的 IMAGE 的 Dockerfile 来进行语法学习：https://github.com/docker-library/


```Dockerfile
# base image 设置
FROM centos
# 运行命令使用 RUN
RUN yum install -y vim
```

+ 制作一个 flask web 应用：

```Dockerfile
FROM python:2.7
LABEL maintainer="Peng Xiao<xiaoquwl@gmail.com>"
RUN pip install flask
COPY app.py /app/
WORKDIR /app
EXPOSE 5000
CMD ["python", "app.py"]
```


#### FROM

用于声明或者定义一个 base image，作为当前 Dockerfile 的基础 

![Text](http://qiniu.jiiiiiin.cn/6j5SrZ.png)



#### LABEL

声明一些 IMAGE 的原始信息

![Text](http://qiniu.jiiiiiin.cn/Pbl2N3.png)

#### Shell 格式和 Exec 格式

![Text](http://qiniu.jiiiiiin.cn/F6CbrZ.png)
![Text](http://qiniu.jiiiiiin.cn/oGqjsV.png)
![Text](http://qiniu.jiiiiiin.cn/c0hBK6.png)


#### RUN

运行一些命令；

没执行一条 RUN 指令，IMAGE 都会新增一层；

***最佳实践：为了美观，复杂的RUN请用反斜线换行！避免无用分层，合并多条命令成一行！***


![Text](http://qiniu.jiiiiiin.cn/ceVdr5.png)

+ RUN ：执行命令并创建新的Image Layer
+ CMD ：设置容器启动后默认执行的命令和参数
+ ENTRYPOINT ：设置容器启动时运行的命令

一般会使用 ENTRYPOINT 来定义 IMAGE 的容器启动之后执行的脚本；

#### CMD

+ 容器启动时默认执行的命令
+ 如果docker run指定了其它命令， CMD命令被忽略

     如：
     ![Text](http://qiniu.jiiiiiin.cn/bFE8mz.png)
     ![Text](http://qiniu.jiiiiiin.cn/FJUoBP.png)

     就不会输出 hello docker；

+ 如果定义了多个CMD ，只有最后一个会执行
+ 可以结合 ENTRYPOINT 来给一个要执行的命令预留指定参数的位置：

![Text](http://qiniu.jiiiiiin.cn/MrWh13.png)
    可以通过一个空的 CMD 来接收参数传递非 ENTRYPOINE 指定的命令；

#### ENTRYPOINT

+ 让容器以应用程序或者服务的形式运行
    
    如启动一个数据库服务，后台进程 
+ 不会被忽略，一定会执行
+ 最佳实践：写一个shelI脚本作为entrypoint

![Text](http://qiniu.jiiiiiin.cn/m42NQT.png)


#### WORKDIR

设定当前的工作目录；

***最佳实践：用WORKDIR，不要用RUN cd ！
尽量使用绝对目录！***

![Text](http://qiniu.jiiiiiin.cn/zLPoG3.png)


#### ADD and COPY

都是将本地的文件添加到IMAGE 中；

+ 区别：

ADD 可以进行解压缩；

大部分情况， COPY优于ADD ！

ADD除了COPY还有额外功能（解压） ！添加远程文件/目录请使用curl或者wget ！

![Text](http://qiniu.jiiiiiin.cn/Q45OjU.png)

+ 在使用 COPY 的时候，如果需要将一个文件 copy
  到容器的对应目录，记得加上“/”，否则就成了复制文件并重命名，而不是移动文件；

#### ENV

设置环境变量；

尽量使用ENV增加可维护性！
![Text](http://qiniu.jiiiiiin.cn/K8LUxJ.png)

#### VOLUME
#### EXPOSE




另外还可以从 docker 仓库去拉取一个 image：


![Text](http://qiniu.jiiiiiin.cn/2sZQ7h.png)

## Container

![Text](http://qiniu.jiiiiiin.cn/O2HSxc.png)
+ 通过Image创建（ copy ）
+ 在Image layer之上建立一个container layer （可读写）
+ 类比面向对象：类和实例
+ Image负责app的存储和分发，Container负责运行app

## 其他

+ 如何让普通用户拥有执行 docker 命令的权限？

> http://coding.imooc.com/lesson/189.html#mid=11615

```bash
sudo groupadd docker

sudo gpasswd -a vagrant docker

sudo service docker restart

exit
#重新登录用户
```

### 发布 image

> [镜像发布](https://coding.imooc.com/lesson/189.html#mid=11620)






