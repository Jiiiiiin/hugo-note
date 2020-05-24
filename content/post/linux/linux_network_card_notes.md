---
title: "Linux_network_card_notes"
date: 2020-03-01T22:56:54+08:00
draft: true
---

<!--more-->


<!-- vim-markdown-toc GFM -->

    * [网络基础](#网络基础)
        * [网络编址](#网络编址)
        * [子网掩码](#子网掩码)
    * [网络间通讯](#网络间通讯)
        * [相同网络间](#相同网络间)
        * [不同网络之间通信](#不同网络之间通信)
        * [路由](#路由)
    * [域名](#域名)
    * [DNS 域名服务](#dns-域名服务)
        * [客户端](#客户端)
        * [查询](#查询)
            * [查询类型](#查询类型)
        * [DNS 资源记录](#dns-资源记录)
        * [DNS 服务器](#dns-服务器)
        * [BIND](#bind)
    * [网络配置](#网络配置)
    * [以太网连接](#以太网连接)
* [配置网络](#配置网络)
    * [网络相关配置文件](#网络相关配置文件)
    * [常用网络命令](#常用网络命令)
    * [修改主机名](#修改主机名)
    * [网络故障排查](#网络故障排查)
    * [linux网络连线设置](#linux网络连线设置)
        * [lo网卡](#lo网卡)
        * [网卡类型](#网卡类型)
* [](#)

<!-- vim-markdown-toc -->

## 网络基础

> [基础网络概念](https://coding.imooc.com/lesson/189.html#mid=11626)

![Text](http://qiniu.jiiiiiin.cn/I72FSW.png)

> [网络基础](https://www.youtube.com/watch?v=isqRtPVggwM&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=14)

### 网络编址

![](http://qiniu.jiiiiiin.cn/CNAGWQ.png)

编址技术很多，ip 是目前使用的；

![](http://qiniu.jiiiiiin.cn/ftWYHK.png)

网络部分标识你住哪，主机部分标识你是谁；

![](http://qiniu.jiiiiiin.cn/f2kEve.png)

+ 上面是 10 进制；
下面是 2 进制标识；
二进制转10 进制，就得到10 进制标识；

+ 二进制表示，分为4 fileds，每一部分有8位；

### 子网掩码

网络部分和主机部分并不是固定程度；

![](http://qiniu.jiiiiiin.cn/dqOJZN.png)

+ 子网掩码用来确定一个ip地址的网络部分；
+ ip 地址必须和子网掩码成对出现，不然无法确认那个是网络部分那个是主机部分；

![](http://qiniu.jiiiiiin.cn/9Y457S.png)

![](http://qiniu.jiiiiiin.cn/kIipSI.png)
![](http://qiniu.jiiiiiin.cn/V2HbQJ.png)
+ /24
  是一个子网掩码的简写，代表前24位是网络部分，写成点分十进制就是`255.255.255.0`
+ 192.168.1.0标识一个网段，下面的A/B/C3台主机都属于这个网段
+ 所以说 ip 为一个双层结构；

## 网络间通讯

### 相同网络间


![](http://qiniu.jiiiiiin.cn/NeZw5p.png)

+ 同一个网段主机间互访，还需要一个 MAC 地址；
+ MAC 地址就是用来做同一网段主机间通信使用；
+ 同一网段内，主机都是通过同一个交换机直连的；
+ 或者两台主机直连；

+ MAC 地址，网卡固化地址；
+ 网卡硬件地址；
+ MAC 地址称为 2 层地址；
+ ip 地址称为 3 层地址；
+ ARP 是在两台机器（同一网段）建立通信开始发送的协议信息，是地址解析协议，即 问谁是 192.168.1.2，请把你的 mac 地址给我；
+ ARP 将向所有相同网段的主机广播，只有确切的那台机器响应，返回自己的MAC地址；
+ 只要自己发现将要请求的 IP 和自己在同一网段都是使用这种方式，拿到 MAC 地址之后，就进行主机间直连；

### 不同网络之间通信

![](http://qiniu.jiiiiiin.cn/ngIghT.png)

+ 需要网关
+ 一般都是使用路由器

+ 路由器就好像快递公司，接受并转发数据；
一次连接可能要进过多个（n 个）路由器之间的转发；

### 路由

![](http://qiniu.jiiiiiin.cn/Q2hKfc.png)

+ ethN就是一个路由器的不同接口；
+ 分别指向一个网段；
+ 在路由表中就记录了一个接口指向那个网段；
+ 主机发现请求的 ip 不是同一个网段就不会发送 ARP
+ 主机会发送给主机上面配置的网关（即路由器）
+ 路由器收到某个网段发送过来的数据，如从eth0接口收到的要发给172...的数据包，路由器就会查询被请求的 IP 是否在路由表中有记录；
+ 如果有，就如上图从 eth0 接收-》eth1 出去；


## 域名

![](http://qiniu.jiiiiiin.cn/eLzhWY.png)
![](http://qiniu.jiiiiiin.cn/goXZRz.png)

+ 上网的时候，需要先定位域名再定位主机；
+ www 约定俗成是网页服务器；提供网页服务；
+ 主机名可以随便定义，也可以不适用 www；

## DNS 域名服务

> [DNS基础及域名系统架构](https://www.youtube.com/watch?v=bpjkDxEAYwU&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=35)

主机如果需要访问外部的服务器（域名需要被解析）一般都需要配置DNS服务器信息；

![](http://qiniu.jiiiiiin.cn/hiipvF.png)

+ 主机间通信还是通过 ip 地址来完成通信的，而不是域名；
+ 域名到 ip 的转换是通过 DNS 来完成
+ DNS 服务由运营商提供；
+ 保存全世界所有域名；
+ 访问一个网站：
+ 在配置网络的时候 主机对应的 DNS 服务也需要配置；
+ 1.选取主机配置的DNS 服务发起请求获取对应域名的 ip 地址

### 客户端

![Text](http://qiniu.jiiiiiin.cn/olS8uo.png)
+ `/etc/hosts` 经常被黑客用来做钓鱼攻击

### 查询

![Text](http://qiniu.jiiiiiin.cn/iMmc8H.png)

![Text](http://qiniu.jiiiiiin.cn/B01d8N.png)
+ `.`代表根DNS服务器，保存一些基础信息，它存储了下级服务器（com/net...）的地址
+ `com/net...`每一级都存储在一台或者多台服务器，分别保存以自己域名结尾的域名信息，如`baidu.com`就存储百度服务器的信息
+ 每个具体的域名，如`baidu.com`还会存在一台
  授权服务器，保存自己下面的自域名的相关信息，一般自己维护或者租用域名服务商提供的DNS域名服务器
+ 通过顶级域名服务器获取对应某个具体域名的ip信息
+ `.`根服务器的信息一般都是自己手动配置的
+ `dig+trace`进行查询追踪
![Text](http://qiniu.jiiiiiin.cn/W4oHHo.png)

#### 查询类型

递归查询

![Text](http://qiniu.jiiiiiin.cn/vSOby3.png)

+ 客户端先查询主机配置的本地DNS服务器，本地DNS在去查询根，一返回在进行二次查询返回结果直到最后得到想要的域名的ip地址

循环查询

![Text](http://qiniu.jiiiiiin.cn/XOoBJm.png)

![Text](http://qiniu.jiiiiiin.cn/9a0Jsv.png)

+ 每次查询之后本地的DNS服务器都会缓存查询结果
+ DNS服务器最主要就是***返回域名和IP的对应信息***

### DNS 资源记录

![Text](http://qiniu.jiiiiiin.cn/XmYcQR.png)
+ 每一条就是一个RR（记录信息）
+ CLASS代表资源类型，IN 为internet
+ TYPE 资源类型，A为ipv4地址/AAAA
  ipv6地址/CNAME代表别名（DNS直接返回别名对应的等同的域名的IP）

  ![Text](http://qiniu.jiiiiiin.cn/kojOJc.png)
+ RDATA真实的数据


### DNS 服务器

类型

![Text](http://qiniu.jiiiiiin.cn/X75KOe.png)

+ 一个域的配置信息是保存在ZONE文件中，详细查看：https://www.youtube.com/watch?v=bpjkDxEAYwU&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=35

### BIND

> [BIND服务基础及域主服务器配置](https://www.youtube.com/watch?v=AwyRfM8ChNw&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=36&pbjreload=10)
> 介绍了chroot 安全防护基本知识

![Text](http://qiniu.jiiiiiin.cn/2RY75M.png)

![Text](http://qiniu.jiiiiiin.cn/s0qpjd.png)



## 网络配置

![](http://qiniu.jiiiiiin.cn/87T9qL.png)

3 个配置项，依次递增，随着主机需要访问的范围越大，需要配置的东西越多；

> [Linux网络基础配置](https://www.youtube.com/watch?v=K_LwdDMck2c&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=15)

## 以太网连接


![](http://qiniu.jiiiiiin.cn/0ojwy3.png)

+ ethN就标识主机的网卡，有几个网卡就有几个以太网接口；
+ eth->Ethernet
+ 通过lspci命令查询得到的网卡信息：`00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)` 网卡 虚拟机模拟的网卡；

# 配置网络

![](http://qiniu.jiiiiiin.cn/QDMvvM.png)
![Text](http://qiniu.jiiiiiin.cn/Mwre2i.png)
![Text](http://qiniu.jiiiiiin.cn/7pShyM.png)
+ 针对服务器我们需要配置静态ip一般，所以这里需要取消DHCP勾线（空格）
+ 在Static IP中配置我们的静态ip地址，子网掩码（Netmask）
+ 配置网关（Default gateway IP），一般为：192.168.1.1/192.168.1.254；
+ 配置DNS（Primary DNS Server），可以配置两个，在这里
+ 之后保存配置即可；
+ 配置完成，使用`ifup`启用网卡，并使用ifconfig查看信息

![Text](http://qiniu.jiiiiiin.cn/Htoo43.png)

## 网络相关配置文件


![](http://qiniu.jiiiiiin.cn/73UKE5.png)

+ 每一张网卡都有一个配置文件如：
`/etc/sysconfig/network-scripts/ifcfg-eth0` 可以直接编辑该文件来配置该网卡接口的信息，等同通过 setup 配置，配置完毕需要重新启用eth0 网卡

![Text](http://qiniu.jiiiiiin.cn/ZsCFIs.png)

+ 网卡配置
![Text](http://qiniu.jiiiiiin.cn/kM78WS.png)

```bash
# 设备名称
DEVICE="eth0"
# 启动协议
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
```
+ DNS配置
![Text](http://qiniu.jiiiiiin.cn/Dlgs1i.png)


## 常用网络命令


![](http://qiniu.jiiiiiin.cn/Ah3HNL.png)
+ 如果ping域名，会先对域名做一次解析得到服务器的ip地址
+ 如果ping通，一般就可以认为主机的网络设备没问题/ip地址和子网掩码应该没问题
+ 测试DNS只需要对主机对应的域名做一次解析即可
+ host后面跟主机名或者主机映射的域名即可，只要返回值就标示主机配置的DNS是正确的
+ 查询网关：

```bash

[vagrant@localhost ~]$ ip route
default via 10.0.2.2 dev eth0 proto dhcp metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100
192.168.33.0/24 dev eth1 proto kernel scope link src 192.168.33.10 metric 101

```

10.0.2.2 就是网关

+ traceroute 追踪请求流经的路由设备

+ 追踪路由链路

```bash
[vagrant@localhost ~]$ tracepath www.ynrcc.com
 1?: [LOCALHOST]                                         pmtu 1500
 1:  gateway                                               0.102ms
 1:  gateway                                               0.303ms
 2:  192.168.3.1                                           3.585ms asymm 64
 3:  192.168.1.1                                           4.615ms asymm 63
 4:  10.78.0.1                                             6.016ms asymm 62
 5:  no reply
 6:  183.224.27.13                                        11.378ms asymm 60
 7:  183.224.30.78                                         9.519ms asymm 59
 8:  no reply
 9:  39.129.1.129                                         10.914ms asymm 57
10:  39.129.13.198                                         8.539ms reached
     Resume: pmtu 1500 hops 10 back 56
[vagrant@localhost ~]$ ping www.ynrcc.com
PING www.ynrcc.com (39.129.13.198) 56(84) bytes of data.
 ^C64 bytes from 39.129.13.198: icmp_seq=1 ttl=63 time=7.66 ms
```


## 修改主机名

![](http://qiniu.jiiiiiin.cn/KEznn6.png)


## 网络故障排查

![](http://qiniu.jiiiiiin.cn/Utib46.png)

## linux网络连线设置

> [RHCE 6】快速學會 Linux 網路連線設定全集-使用NetworkManager設定網路連線](https://www.youtube.com/watch?v=hnuzo5pNrFE)


![Text](http://qiniu.jiiiiiin.cn/loYv59.png)

+ 桌面一般使用NetworkManager应用，因为其可以自动适配网络，比如从有线切换无线网络等；
+ 而服务器一般使用 Network service服务来进行设置；

### lo网卡

```bash
[vagrant@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
```

LOOPBACK是一张假网卡，这张卡的作用是，当我们其他网卡都损坏之后，我们还可以通过这张网卡进行网络测试，比如有一个web服务，就可以使用
`127.0.0.1`进行服务测试；
+ 任何送到这张网卡的封包，等于都是送到本机的该网卡之上；
+ 这个绕了一圈的过程就成为 LOOPBACK

### 网卡类型

```bash
ethN 以太网卡
brN 桥接器
virbrN 虚拟桥接器
```
![Text](http://qiniu.jiiiiiin.cn/sKXpxP.png)




# 

> [Linux网卡绑定、子接口 [LinuxCast视频教程]](https://www.youtube.com/watch?v=PbysL3ATn5k&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=27)



