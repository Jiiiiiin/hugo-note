---
title: "Docker_network Notes"
date: 2020-03-15T13:13:30+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [单机网络](#单机网络)
* [linux 网络命名空间](#linux-网络命名空间)
    * [linux 网络命名空间操作](#linux-网络命名空间操作)
    * [veth pair](#veth-pair)
* [bridge](#bridge)
    * [访问外网：](#访问外网)
    * [新建bridge](#新建bridge)
    * [查看容器连接到bridge网络的ip地址](#查看容器连接到bridge网络的ip地址)
* [link](#link)
* [容器的端口映射](#容器的端口映射)
* [docker host/none drive](#docker-hostnone-drive)
    * [host类型网络](#host类型网络)
* [多机网络通信](#多机网络通信)

<!-- vim-markdown-toc -->

参考：

> [docker 网络](https://coding.imooc.com/lesson/189.html#mid=11625)


## 单机网络

![Text](http://qiniu.jiiiiiin.cn/uaK4dW.png)

## linux 网络命名空间

+ 容器的network namespace和宿主机的network namespace是完全不同的两组接口；
+ 依赖linux network namespace实现容器和主机网络的隔离
+ 不同容器（就算是相同的image）都有自己的一套 network namespace;
+ 相同宿主机上面运行的容器之间的网络是互通的；

+ 示例，可以先创建两个容器：

![Text](http://qiniu.jiiiiiin.cn/X10bKU.png)

`-d`在后台运行一个长期工作的容器，这样这个容器运行的sh进程就会一直在后台执行；



### linux 网络命名空间操作

+ `ip a`查看不同主机（宿主机或者容器）的网络命名空间
    ![Text](http://qiniu.jiiiiiin.cn/CluPVw.png)
    两个不同的容器执行结果；

+ 宿主机和容器（不同容器之间）是不同的网络命名空间

+ 宿主机只要创建了一个容器，就会创建一个叫做 docker0的网络命名空间

+ docker底层就是使用linux 网络命名空间来隔离宿主机和容器的网络命名空间

+ 查看本机的network namespace：`sudo ip netns list`

    输出本机的网络命名空间的名称；

+ 删除一个NN(network namespace)：`sudo ip netns delete NN_NAME`

+ 创建NN：`sudo ip netns add NN_NAME`
![Text](http://qiniu.jiiiiiin.cn/lql444.png)
+ 在对应名称的NN中执行`ip a`命令，这样就查看了对应NN的接口网络信息：`sudo ip netns exec NN_NAME ip a` 或者使用 `sudo ip netns exec NN_NAME ip link`
![Text](http://qiniu.jiiiiiin.cn/8U8lzk.png)
+ 修改NN接口状态（启动）：`sudo ip netns exec NN_NAME ip link set dev lo
  up`，让lo接口up起来；

![Text](http://qiniu.jiiiiiin.cn/CWJtst.png)

### veth pair

![Text](http://qiniu.jiiiiiin.cn/hQttEK.png)

+ veth就类似一个网线的接口

+ 可以在两个容器的NN之间使用Veth
  pair，分别指定两个ip地址，使得两个容器网络打通；

  - 在宿主机node1中执行：`sudo ip link add veth-test1 type veth peer name
    veth-test2`，即在宿主机中添加一对名为 veth-test1/veth-test2的pair

    ![Text](http://qiniu.jiiiiiin.cn/Bf3161.png)

    就在宿主机上创建了两个接口，只有MAC地址还没有ip地址；
    状态为DOWN；

    这里就类似上图在黄色（宿主机）部分添加了两个网卡；

  - 之后 `sudo ip link set veth-test1 netns test1` ，将veth-test1接口添加到test1
    netns（netwrok namespace）中；

    ![Text](http://qiniu.jiiiiiin.cn/Ov93VN.png)

    执行完上面的link set之后：

    ![Text](http://qiniu.jiiiiiin.cn/QEgXC3.png)

    veth-test1接口就被添加到test1
    netns中了，之后本地的ip中对应的veth-test1也就不见了；

    那么我们就完成了将本地创建的veth接口添加到指定的netns中；

    跟着将另外一个也做修改：`sudo ip link set veth-test2 netns test2`

    得到：

    ![Text](http://qiniu.jiiiiiin.cn/sfZyS7.png)

  这样几句完成了最开始那张图的网络状态设置；

+ 添加ip地址并启动接口

![Text](http://qiniu.jiiiiiin.cn/bANFzT.png)

+ 添加完成之后默认还需要启动端口：

![Text](http://qiniu.jiiiiiin.cn/ZjV3Gb.png)

![Text](http://qiniu.jiiiiiin.cn/m7IUDS.png)

目前就建立好了两个netns中的接口就通了：

![Text](http://qiniu.jiiiiiin.cn/hYFVbE.png)

***而docker run实现的两个容器的网络互通的远离其实就和上面类似***
![Text](http://qiniu.jiiiiiin.cn/WGMyc7.png)
## bridge

> [bridge0详解](https://coding.imooc.com/lesson/189.html#mid=11628)

+ 容器能访问外部网络
+ `docker network ls` 可以列举当前宿主机上面docker服务有那些网络
+ `[vagrant@localhost ~]$ docker network inspect 64a83cf04297` inspect 跟NETWORK
  ID，其中输出的：
  ![Text](http://qiniu.jiiiiiin.cn/TWLNaS.png)
  ![Text](http://qiniu.jiiiiiin.cn/eXLok4.png)

  就标示该容器连接到这个网络；

+ `ip a` 查看得到一个宿主机的 `docker0` netns：

```bash
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:f6:53:e8:ff brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:f6ff:fe53:e8ff/64 scope link
       valid_lft forever preferred_lft forever
```
+ 容器的veth网络就需要连接主机的veth之后通过宿主机的对应的veth连接到这个 docker0 netns；

![Text](http://qiniu.jiiiiiin.cn/x8B1bi.png)

+ 验证veth对应接口是连接到docker0：

![Text](http://qiniu.jiiiiiin.cn/LDfp7n.png)
![Text](http://qiniu.jiiiiiin.cn/jgEsim.png)
![Text](http://qiniu.jiiiiiin.cn/AyyUKV.png)

brctl可能需要安装；

+ 上图可以看到docker是在容器和宿主机之间创建了一对veth对，然后和宿主机的docker0连接；
+ 这样就实现了通过docker0来达到不同容器之间的连接
+ 也实现了容器和宿主机之间的连接
+ 也实现了通过docker0访问外部网络；


### 访问外网：

![Text](http://qiniu.jiiiiiin.cn/Oje8bs.png)

### 新建bridge

![Text](http://qiniu.jiiiiiin.cn/hGS1uT.png)

![Text](http://qiniu.jiiiiiin.cn/0BUxFz.png)

![Text](http://qiniu.jiiiiiin.cn/akDw3k.png)

新建容器的时候可以指定使用自建的这个bridge网络；

![Text](http://qiniu.jiiiiiin.cn/lLMOIV.png)

![Text](http://qiniu.jiiiiiin.cn/87acH6.png)
+ 这样test2容器就连接到了两个网络中
+ 另外如果两个容器都连接到自己创建的bridge网络，那么两个容器默认就是被`link`状态，即可以通过容器名ping通
+ 而默认的docker0 bridge是需要手动进行link的
+ 这也是这两种bridge的区别

### 查看容器连接到bridge网络的ip地址

`docker network inspect bridge`
![Text](http://qiniu.jiiiiiin.cn/OJ5oYi.png)


## link

+ 让两个容器之间能通过类似“主机名”的方式进行访问，而不是ip方式

    ![Text](http://qiniu.jiiiiiin.cn/xPuXk7.png)
+ 还可以ping通容器名字`ping test1`
+ link具有方向性，类似在test2中做了一条DNS记录，test2就类似域名，然后link就在test1中记录了名字和ip的对应
+ 在实际中使用场景并不多

+ 更复杂的应用，一个服务（容器1）内部去访问另外一个服务（容器2运行rides）：
    ![Text](http://qiniu.jiiiiiin.cn/SHBOqb.png)

    REDIS_HOST
 是在设置当前容器系统的对应key的环境变量，为容器2的名称，这样使用link的方式就能实现两个容器的网络能通过名称的方式互访；
    ![Text](http://qiniu.jiiiiiin.cn/6jgz4v.png)
    > https://coding.imooc.com/lesson/189.html#mid=11632




## 容器的端口映射

+ 默认容器启动的服务，在宿主机中是能访问的，比如启动了一个nginx容器，宿主机能访问这个web服务
+ 我们可以通过端口映射将nginx容器的服务映射到宿主机的对应端口，向外提供服务
+ 默认容器启动的服务，除了宿主机，外面是访问不到的


-p[ort map] 端口映射，先指定要被映射的容器中的对应端口，如
80，后面在指定宿主机的映射端口 如 80

![Text](http://qiniu.jiiiiiin.cn/9GQZQ6.png)

![Text](http://qiniu.jiiiiiin.cn/femHSz.png)

这样宿主机的80端口就映射到了nginx服务；

网络流向图类似：

![Text](http://qiniu.jiiiiiin.cn/OAbjHV.png)


## docker host/none drive

 ```bash
 [vagrant@localhost network-scripts]$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
64a83cf04297        bridge              bridge              local
e2f281263955        host                host                local
d47e2631cab1        none                null                local
 ```

![Text](http://qiniu.jiiiiiin.cn/jFne5x.png)

+ 使用 `--network none`将新建的容器的网络类型指定为none

+ 查看对应网络类型的信息：`[vagrant@localhost network-scripts]$ docker network inspect none`

    ![Text](http://qiniu.jiiiiiin.cn/C9B7jz.png)

    看见容器没有分配到ip地址；

+ 这种容器只能通过`docker exec -it CONTAINER_NAME
  /bin/bash`这种方式访问，而不能通过网络进行访问

一般不会使用`none`类型的网络；


### host类型网络

使用`--network host`创建一个容器，之后可以进入到容器中查看其的网络命名空间`ip a`，可以看到这种网络类型的容器创建的网络和宿主机的网络命名空间是一致的；

+ 这种方式创建的容器没有自己动力的netns
+ 其和主机共享一套netns
+ 这种方式可能导致宿主机的端口被容器所启动的服务占用


## 多机网络通信

> [4-9 Overlay和Underlay的通俗解释](https://coding.imooc.com/lesson/189.html#mid=11633)

![Text](http://qiniu.jiiiiiin.cn/8axzPM.png)
+ 通过“再封包”类似机制，将容器发向另外一个容器的封包，打包在原始宿主机间通讯的数据包之上实现多机数据包传递；
+ 底层通过VXLAN技术实现
    ![Text](http://qiniu.jiiiiiin.cn/oaj9ul.png)
+ 类似隧道










