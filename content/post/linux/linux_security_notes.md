---
title: "Linux_security_notes"
date: 2020-03-07T22:07:22+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [Firewall](#firewall)
* [IPTables](#iptables)
    * [规则 PARAMETERS](#规则-parameters)
    * [基本操作](#基本操作)
    * [匹配参数](#匹配参数)
        * [FORWARD](#forward)
        * [NAT](#nat)
    * [TARGETS](#targets)
* [最佳实践](#最佳实践)

<!-- vim-markdown-toc -->

网络访问控制
+ Linux一般都是作为服务器系统使用，对外提供一些基于 网络的服务·通常我们都需要对服务器进行一些网络访问控制，类似防火墙的功能
+ 常见的访问控制包括：哪些IP可以访问服务器、可以使用哪些协议、哪些接口、是否需要对数据包进行修改等等
+ 如服务器可能受到来自某IP的攻击，这时就需要禁止所有来自该IP的访问
+ Linux内核集成了网络访问控制功能，通过netfilter模块实现

## Firewall

> [1.何謂防火牆 (ppt1~6)](https://www.youtube.com/watch?v=xV0WMHxGR7c)

![Text](http://qiniu.jiiiiiin.cn/jzA6Vx.png)
![Text](http://qiniu.jiiiiiin.cn/Zbz1Z0.png)
![Text](http://qiniu.jiiiiiin.cn/r6946F.png)
内部主机可以通过防火墙送出到外部网络；

外部流量会受到防火墙规则的管控；
![Text](http://qiniu.jiiiiiin.cn/OMNKJZ.png)
 防火墙就是一个安全政策控制点；

## IPTables

> [netfilter及iptables基本概念 [LinuxCast视频教程]](https://www.youtube.com/watch?v=RO3ug2Y5q3o&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=31)
> [iptables LINUX 防火牆基礎教學 中文講解 1/3](https://www.youtube.com/watch?v=sQMFgk5_uo0&t=149s)

Linux内核通过netfilter模块实现网络访问控制功能，在用户层我们可以通过iptables程序对netfilter进行控制管理。
+ netfilter可以对数据进行允许、丢弃、修改操作
+ netfilter支持通过以下方式对数据包进行分类：
    - 源IP地址
    - 目标IP地址
    - 使用接口
    - 使用协议（TCP、UDP、ICMP等）， 端口号
    - 连接状态（new、 ESTABLISHED、 RELATED、INVALID）

![Text](http://qiniu.jiiiiiin.cn/IELYpX.png)
![Text](http://qiniu.jiiiiiin.cn/TtOyLC.png)
+ filter （chain） 用以对数据进行过滤
    - filter 是默认 table 如果 iptables 指令没有指定 table 那默认就是 filter
    - 这个 table 的预设 chains 是：INPUT、FORWARD、OUTPUT
    - 使用`[vagrant@localhost ~]$ sudo iptables -t -L`查看当前系统 filter table
      设置的规则
+ nat用以对数据包的源、目标地址进行修改
    - 使用`[vagrant@localhost ~]$ sudo iptables -t nat -L`查看规则
+ mangle用以对数据包进行高级修改

![Text](http://qiniu.jiiiiiin.cn/3bT3Zz.png)
![Text](http://qiniu.jiiiiiin.cn/TuLwhX.png)
 图的左边代表数据包从网卡进入；
 + PREROUTING chain 标识路由前
 + 进入路由之后有两个结果，如果目的地是自己就送给 INPUT chain，否则送给
   FORWARD chain，标识当前主机需要转发这个数据包
 + 凡是进入 INPUT chain 的数据包都会进入到主机的某个进程
 + 进入到 INPUT chain 的数据包不会再导向到 FORWARD chain
 + 比如内部某台机器流经主机（这里主机作为一个路由使用）需要访问外网每个
   ip，那么就会进入 FORWARD chain
 + 离开网卡之前有一个 POSTROUTING chain
 + INPUT chain 的数据包的流向是主机的防火墙本身内部的某个程序，即目的地是自己；
 + FORWARD chain 只是流经主机需要访问外部的数据包；
 + 而 OUTPUT chain 上面可以控制主机的程序向外访问时候是否合规的控制，即发出数据包的目的地是否允许允许流出；
 + 另外一个外部设备要连接主机，我们先要确定会连到那张网卡（ifconfig#ethX），这个网卡就是接收数据包的位置，而如果是进来的那么势必进过 INPUT chain



![Text](http://qiniu.jiiiiiin.cn/sjSxro.png)
对转发数据源、目标 ip 进程修改需要用的不是 forward 而是 PRE/POSTROUTING;


### 规则 PARAMETERS
+ iptables通过规则对数据进行访问控制
+ 一个规则使用一行配置
+ 规则按顺序排列
+ 当收到、发出、转发数据包时，使用规则对数据包进行匹配，按规则顺序进行逐条匹配
+ 数据包按照第一个匹配上的规则执行相关动作：丢弃、放行、修改·没有匹配规则，则使用默认动作（每个chain拥有各自的默认动作）
![Text](http://qiniu.jiiiiiin.cn/ufSpvs.png)

+ 一般都是先写限定范围 table 和 chain，如：`-t filter -A INPUT`
+ 之后定义规则，如`-i eth0`, 之后描述数据包是什么样子的，如 `-p tcp
  --dport22`，这 3 个都是规则或者说条件
+ 最后定义一个动作：如 `-j DROP`

```bash
# 将 eth0 接收到的发送到主机 21tcp 服务的数据包将其丢弃
iptables -t filter -A INPUT -i eth0 -p tcp -dport 21 -j DROP
```

+ 如果想单独放行某一个 ip：
再添加下面这条配置：

![Text](http://qiniu.jiiiiiin.cn/0qCKGx.png)

-A[pend] 是讲新的规则加到原有规则的下方 

### 基本操作

![Text](http://qiniu.jiiiiiin.cn/8nUVEt.png)

### 匹配参数

![Text](http://qiniu.jiiiiiin.cn/ACzY3n.png)

-s 跟 ip 地址；

-d 跟地址段；

-i 匹配接收接口（网卡）；

-o 匹配发送（数据）的接口；

***'!'*** 表示取反操作；

+ 例子：
![Text](http://qiniu.jiiiiiin.cn/ELPEl8.png)

#### FORWARD

当使用Linux作为路由（进行数据转发）设备使用的时候，可以通过定义forward规则来进行转发控制

如：
禁止所有来自于192. 168.1.0/24 发送到10.1.1.0/24的流量：
```bash
iptabels -A FORWARD -s 192.168.1.0/24 -d 10.1.1.0/24 -j DROP
```

#### NAT
INAT （Network Address Translation）网络地址转换是用来对数据包的IP地址进行修改的机制，NAT分 为两种：
+ SNAT源地址转换，通常用于伪装内部地址（一
  般意义上的NAT），一般是将内网的主机，统一转换成一个公网地址去访问外网；

+ DNAT目标地址转换，通常用于跳转，所谓跳转一般就是将流向自己的流量导向到内部的其他机器，类似反向代理；

+ iptables中实现NAT功能的是NAT表

![Text](http://qiniu.jiiiiiin.cn/MI8Rg5.png)

注意 DNAT 只能用于 PREROUTING 过滤点；

 示例 1 就是修改所有到 80 的网页流量，导向到新的主机地址；

 -j 标识执行的动作是 DNAT；

 示例 3 表示主机的 eth0 是链接到公网的（是一个公网 ip
 地址），通过这个配置将所有发送出去的数据包的源 ip 地址伪装成这个公网
 IP地址，这样的好处就是内网的主机就都可以访问互联网了；

 注意源地址的转换需要在 POSTROUTING 过滤点上面；

 -j MASQUERADE 意思就是伪装，伪装成-o 参数指定的 eth0 网卡对应的地址；

 最后一个示例就是讲源地址伪装成一个没啥意义的地址，这样做是为了不暴露源地址；

 ## 配置文件

+ 通过iptables添加的规则并不会永久保存，如果需要永久保存规则，则需要将规则保存在/etc/sysconfig/iptables配置文件中
+ 可以通过以下命令将iptables规则写入配置文件：srvice iptables save
+ CentOS/RHEL 系统会带有默认iptables规则，默认保存在/etc/sysconfig/iptables中，保存自定义规则会覆盖这些默认规则

### TARGETS

类型：

```bash
ACCEPT: 让封包通过防火墙
DROP：直接丢弃封包，切不会返回任何信息给调用者
???END
RETURN：TODO
```

用来决定对满足规则的封包做什么事情；



 
## 最佳实践

 如果是远程管理一个Linux主机并修改iptables规则，则必须先允许来自客户端主机的SSH流量确保这是第一条iptables规则，
 否则可能会由于配置失误将自己锁在外面！


