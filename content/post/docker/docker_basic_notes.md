---
title: "Docker_basic_notes"
date: 2020-03-05T13:30:35+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
* [名词](#名词)
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
* [容器的资源限制](#容器的资源限制)
* [底层技术](#底层技术)
* [linux中执行docker使用docker组](#linux中执行docker使用docker组)
    * [发布 image](#发布-image)

<!-- vim-markdown-toc -->


## 常用命令

```bash
启动 dockerd: sudo service docker start 

停止dockerd服务：service docker stop

检查docker启动状态：docker version

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

-e 指定一个环境变量在创建容器的时候；

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


# Network

# 可以列举当前宿主机上面docker服务有那些网络
docker network ls 

# 创建网络

# 创建drive是overlay 类型的一个网络名称叫demo
vagrant@docker-node1:~$ sudo docker network create -d overlay demo

# volume 相关

# 查看volume列表

docker volume ls

# 删除volume（注意即使对应的容器被删除，但是不会集联删除其创建的volume，需要手动删除，或者应该主动备份这个数据）
docker volume rm VOLUME_NAME

# 查看对应NAME的volume的细节
docker volume inspect VOLUME_NAME
```

## 名词

+ 进程
> 无论用哪种语言编写这段代码，最后都需要通过某种方式翻译成二进制文件，才能在计算机操作系统中运行起来
> 而为了能够让这些代码正常运行，我们往往还要给它提供数据，比如我们这个加法程序所需要的输入文件。这些数据加上代码本身的二进制文件，放在磁盘上，就是我们平常所说的一个“程序”，也叫代码的可执行镜像（executable image）。
> 首先，操作系统从“程序”中发现输入数据保存在一个文件中，所以这些数据就会被加载到内存中待命。同时，操作系统又读取到了计算加法的指令，这时，它就需要指示 CPU 完成加法操作。而 CPU 与内存协作进行加法计算，又会使用寄存器存放数值、内存堆栈保存执行的命令和变量。同时，计算机里还有被打开的文件，以及各种各样的 I/O 设备在不断地调用中修改自己的状态。就这样，一旦“程序”被执行起来，它就从磁盘上的二进制文件，变成了计算机内存中的数据、寄存器里的值、堆栈中的指令、被打开的文件，以及各种设备的状态信息的一个集合。像这样一个程序运行起来后的计算机执行环境的总和，就是我们今天的主角：进程。

> 所以，对于进程来说，它的静态表现就是程序，平常都安安静静地待在磁盘上；而一旦运行起来，它就变成了计算机里的数据和状态的总和，这就是它的动态表现。而容器技术的核心功能，就是通过约束和修改进程的动态表现，从而为其创造出一个“边界”。

+ Linux Namespace

> 基于 Linux Namespace 的隔离机制相比于虚拟化技术也有很多不足之处，其中最主要的问题就是：隔离得不彻底。首先，既然容器只是运行在宿主机上的一种特殊的进程，那么多个容器之间使用的就还是同一个宿主机的操作系统内核。
Linux 里面的 Namespace 机制。而 Namespace 的使用方式也非常有意思：它其实只是 Linux 创建新进程的一个可选参数。

> Linux 里面的 Namespace 机制。而 Namespace 的使用方式也非常有意思：它其实只是 Linux 创建新进程的一个可选参数。比如，Mount Namespace，用于让被隔离进程只看到当前 Namespace 里的挂载点信息；Network Namespace，用于让被隔离进程看到当前 Namespace 里的网络设备和配置。

> Docker 容器这个听起来玄而又玄的概念，实际上是在创建容器进程时，指定了这个进程所需要启用的一组 Namespace 参数。这样，容器就只能“看”到当前 Namespace 所限定的资源、文件、设备、状态，或者配置。而对于宿主机以及其他不相关的程序，它就完全看不到了。

> Namespace 技术实际上修改了应用进程看待整个计算机“视图”，即它的“视线”被操作系统做了限制，只能“看到”某些指定的内容。但对于宿主机来说，这些被“隔离”了的进程跟其他进程并没有太大区别

![Text](https://static001.geekbang.org/resource/image/9f/59/9f973d5d0faab7c6361b2b67800d0e59.jpg)
> 在这个对比图里，我们应该把 Docker 画在跟应用同级别并且靠边的位置。这意味着，用户运行在容器里的应用进程，跟宿主机上的其他进程一样，都由宿主机操作系统统一管理，只不过这些被隔离的进程拥有额外设置过的 Namespace 参数。而 Docker 项目在这里扮演的角色，更多的是旁路式的辅助和管理工作。

+ 和虚拟机的区别

> 根据实验，一个运行着 CentOS 的 KVM 虚拟机启动后，在不做优化的情况下，虚拟机自己就需要占用 100~200 MB 内存。此外，用户应用运行在虚拟机里面，它对宿主机操作系统的调用就不可避免地要经过虚拟化软件的拦截和处理，这本身又是一层性能损耗，尤其对计算资源、网络和磁盘 I/O 的损耗非常大。而相比之下，容器化后的用户应用，却依然还是一个宿主机上的普通进程，这就意味着这些因为虚拟化而带来的性能损耗都是不存在的；而另一方面，使用 Namespace 作为隔离手段的容器并不需要单独的 Guest OS，这就使得容器额外的资源占用几乎可以忽略不计。

+ Linux Cgroups 

> 就是 Linux 内核中用来为进程设置资源限制的一个重要功能。

> 虽然容器内的第 1 号进程在“障眼法”的干扰下只能看到容器里的情况，但是宿主机上，它作为第 100 号进程与其他所有进程之间依然是平等的竞争关系。这就意味着，虽然第 100 号进程表面上被隔离了起来，但是它所能够使用到的资源（比如 CPU、内存），却是可以随时被宿主机上的其他进程（或者其他容器）占用的。当然，这个 100 号进程自己也可能把所有资源吃光。这些情况，显然都不是一个“沙盒”应该表现出来的合理行为。
> Linux Cgroups 的全称是 Linux Control Group。它最主要的作用，就是限制一个进程组能够使用的资源上限，包括 CPU、内存、磁盘、网络带宽等等。
> Linux Cgroups 的设计还是比较易用的，简单粗暴地理解呢，它就是一个子系统目录加上一组资源限制文件的组合。
> 而对于 Docker 等 Linux 容器项目来说，它们只需要在每个子系统下面，为每个容器创建一个控制组（即创建一个新目录），然后在启动容器进程之后，把这个进程的 PID 填写到对应控制组的 tasks 文件中就可以了。

> Linux Cgroups 的设计还是比较易用的，简单粗暴地理解呢，它就是一个子系统目录加上一组资源限制文件的组合。而对于 Docker 等 Linux 容器项目来说，它们只需要在每个子系统下面，为每个容器创建一个控制组（即创建一个新目录），然后在启动容器进程之后，把这个进程的 PID 填写到对应控制组的 tasks 文件中就可以了。
> https://time.geekbang.org/column/article/14653

Namespace 的作用是“隔离”，它让应用进程只能看到该 Namespace 内的“世界”；而 Cgroups 的作用是“限制”，它给这个“世界”围上了一圈看不见的墙。这么一折腾，进程就真的被“装”在了一个与世隔绝的房间里，而这些房间就是 PaaS 项目赖以生存的应用“沙盒”
+ 单进程 
> 这是因为容器本身的设计，就是希望容器和应用能够同生命周期，这个概念对后续的容器编排非常重要。否则，一旦出现类似于“容器是正常运行的，但是里面的应用早已经挂了”的情况，编排系统处理起来就非常麻烦了。

+ Change Root
>而这个挂载在容器根目录上、用来为容器进程提供隔离后执行环境的文件系统，就是所谓的“容器镜像”。它还有一个更为专业的名字，叫作：rootfs（根文件系统）。 你应该可以理解，对 Docker 项目来说，它最核心的原理实际上就是为待创建的用户进程：启用 Linux Namespace 配置；设置指定的 Cgroups 参数；切换进程的根目录（Change Root）。 https://time.geekbang.org/column/article/17921
> 需要明确的是，rootfs 只是一个操作系统所包含的文件、配置和目录，并不包括操作系统内核。
> 由于 rootfs 里打包的不只是应用，而是整个操作系统的文件和目录，也就意味着，应用以及它运行所需要的所有依赖，都被封装在了一起。

+ layer
> 这也正是为何，Docker 公司在实现 Docker 镜像时并没有沿用以前制作 rootfs
> 的标准流程，而是做了一个小小的创新：Docker
> 在镜像的设计中，引入了层（layer）的概念。也就是说，用户制作镜像的每一步操作，都会生成一个层，也就是一个增量
> rootfs。当然，这个想法不是凭空臆造出来的，而是用到了一种叫作联合文件系统（Union
> File System）的能力。Union File System 也叫
> UnionFS，最主要的功能是将多个不同位置的目录联合挂载（union
> mount）到同一个目录下。

既然容器的 rootfs（比如，Ubuntu 镜像），是以只读方式挂载的，那么又如何在容器里修改 Ubuntu 镜像的内容呢？（提示：Copy-on-Write）
1. 上面的读写层通常也称为容器层，下面的只读层称为镜像层，所有的增删查改操作都只会作用在容器层，相同的文件上层会覆盖掉下层。知道这一点，就不难理解镜像文件的修改，比如修改一个文件的时候，首先会从上到下查找有没有这个文件，找到，就复制到容器层中，修改，修改的结果就会作用到下层的文件，这种方式也被称为copy-on-write。

+ Docker Volume

> https://time.geekbang.org/column/article/18119
> 而这里要使用到的挂载技术，就是 Linux 的绑定挂载（bind mount）机制。它的主要作用就是，允许你将一个目录或者文件，而不是整个设备，挂载到一个指定的目录上。并且，这时你在该挂载点上进行的任何操作，只是发生在被挂载的目录或者文件上，而原挂载点的内容则会被隐藏起来且不受影响。

![Text](https://static001.geekbang.org/resource/image/2b/18/2b1b470575817444aef07ae9f51b7a18.png)
这个容器进程“python app.py”，运行在由 Linux Namespace 和 Cgroups 构成的隔离环境里；而它运行所需要的各种文件，比如 python，app.py，以及整个操作系统文件，则由多个联合挂载在一起的 rootfs 层提供。这些 rootfs 层的最下层，是来自 Docker 镜像的只读层。在只读层之上，是 Docker 自己添加的 Init 层，用来存放被临时修改过的 /etc/hosts 等文件。而 rootfs 的最上层是一个可读写层，它以 Copy-on-Write 的方式存放任何对只读层的修改，容器声明的 Volume 的挂载点，也出现在这一层。
+ 容器

> 容器其实是一种沙盒技术。顾名思义，沙盒就是能够像一个集装箱一样，把你的应用“装”起来的技术。这样，应用与应用之间，就因为有了边界而不至于相互干扰；而被装进集装箱的应用，也可以被方便地搬来搬去，这不就是 PaaS 最理想的状态嘛。

> https://time.geekbang.org/column/article/14642
从这个结构中我们不难看出，一个正在运行的 Linux 容器，其实可以被“一分为二”地看待：一组联合挂载在 /var/lib/docker/aufs/mnt 上的 rootfs，这一部分我们称为“容器镜像”（Container Image），是容器的静态视图；一个由 Namespace+Cgroups 构成的隔离环境，这一部分我们称为“容器运行时”（Container Runtime），是容器的动态视图。
+ 编排

> “编排”（Orchestration）在云计算行业里不算是新词汇，它主要是指用户如何通过某些工具或者配置来完成一组虚拟机以及关联资源的定义、配置、创建、删除等工作，然后由云计算平台按照这些指定的逻辑来完成的过程。而容器时代，“编排”显然就是对 Docker 容器的一系列定义、配置和创建动作的管理。而 Fig 的工作实际上非常简单：假如现在用户需要部署的是应用容器 A、数据库容器 B、负载均衡容器 C，那么 Fig 就允许用户把 A、B、C 三个容器定义在一个配置文件中，并且可以指定它们之间的关联关系，比如容器 A 需要访问数据库容器 B。
> Fig 就会把这些容器的定义和配置交给 Docker API 按照访问逻辑依次创建，你的一系列容器就都启动了；而容器 A 与 B 之间的关联关系，也会交给 Docker 的 Link 功能通过写入 hosts 文件的方式进行配置。更重要的是，你还可以在 Fig 的配置文件里定义各种容器的副本个数等编排参数，再加上 Swarm 的集群管理能力，一个活脱脱的 PaaS 呼之欲出。Fig 项目被收购后改名为 Compose，它成了 Docker 公司到目前为止第二大受欢迎的项目，一直到今天也依然被很多人使用。

+ Prometheus

> 容器监控事实标准

+ Swarm
> 内置容器编排、集群管理和负载均衡能力，固然可以使得 Docker 项目的边界直接扩大到一个完整的 PaaS 项目的范畴，但这种变更带来的技术复杂度和维护难度，长远来看对 Docker 项目是不利的

+ 微服务治理项目 Istio



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


另外还可以从 docker 仓库去拉取一个 image：


![Text](http://qiniu.jiiiiiin.cn/2sZQ7h.png)
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

但是，默认情况下，Docker 会为你提供一个隐含的 ENTRYPOINT，即：/bin/sh
-c。所以，在不指定 ENTRYPOINT
时，比如在我们这个例子里，实际上运行在容器里的完整进程是：`/bin/sh -c "python
app.py"`，即CMD 的内容就是 ENTRYPOINT 的参数。
https://time.geekbang.org/column/article/18119



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
    
    另外可以在CMD中定义一个默认参数；


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

> [EXPOSE 声明端口](https://yeasy.gitbooks.io/docker_practice/image/dockerfile/expose.html)

> 格式为 EXPOSE <端口1> [<端口2>...]。
> EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。
> 
> 要将 EXPOSE 和在运行时使用 -p <宿主端口>:<容器端口> 区分开来。-p，是映射宿主端口和容器端口，换句话说，就是将容器的对应端口服务公开给外界访问，而 EXPOSE 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。






## Container

![Text](http://qiniu.jiiiiiin.cn/O2HSxc.png)
+ 通过Image创建（ copy ）
+ 在Image layer之上建立一个container layer （可读写）
+ 类比面向对象：类和实例
+ Image负责app的存储和分发，Container负责运行app

## 容器的资源限制

+ 默认容器会尽量占用宿主机的所有资源；
+ 如果不做限制可能出现容器中允许的进程将宿主机内存耗尽的问题；
+ `docker run --help` 查询docker允许容器的可用参数；

```bash
-m, --memory bytes                   Memory limit
--memory-swap bytes              Swap limit equal to memory plus swap: '-1' to enable unlimited swap
```

如果仅仅指定了 -m 而没有指定 下面的swap memory，那么swap
memory就等于-m设置的大小；

![Text](http://qiniu.jiiiiiin.cn/TT78Nl.png)
![Text](http://qiniu.jiiiiiin.cn/I3ULvO.png)

+ 指定容器所占的cpu的权重 `-c, --cpu-shares int                 CPU shares
  (relative weight)`

![Text](http://qiniu.jiiiiiin.cn/gZb2dn.png)

上图显示了两个进程，分别一个占用三分之一，一个占用三分之二的情况；

## 底层技术

TODO

![Text](http://qiniu.jiiiiiin.cn/4Y0lZO.png)

+ 底层使用 namespaces来支持容器拥有自己的文件系统，用户，进程等
+ control groups 用来做容器的资源限制如内存和cpu的限制



## linux中执行docker使用docker组

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






