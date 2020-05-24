---
title: "Vagrant_notes"
date: 2020-03-04T12:03:08+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [vagrant](#vagrant)
    * [Boxes](#boxes)
* [网络配置](#网络配置)
    * [端口转发](#端口转发)
    * [私有网络](#私有网络)
* [公有网络](#公有网络)
* [Plugins](#plugins)
    * [scp](#scp)
* [VirtualBox](#virtualbox)

<!-- vim-markdown-toc -->


## vagrant

vagrant 能提供：

```bash
config.vm.box - Operating System
 声明所使用的的虚机的操作系统，或者说 vagrant box；

config.vm.provider - virtualbox
config.vm.network - How  your host sees your box
config.vm.synced folder - How you access files from your computer
config.vm.provision - what we want setup
```

### Boxes

> [如何在vagrant官网下载各种最新.box资源](https://blog.csdn.net/shadow_zed/article/details/95032965)

> [获取 Vagrant官网box 下载链接](https://blog.csdn.net/xwx_100/article/details/84673522)

## 网络配置

+ 私有网络
+ 公有网络
+ 端口转发


### 端口转发


```ruby

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network :forwarded_port, guest: 80, host: 8080
end
```
+ 把宿主机器的8080端口转发到vagrant创建的虚拟机的80端口，以便能在vagrant创建的虚拟机外部访问。
+ 此时使用宿主机器的浏览器打开http://127.0.0.1:8080就可以看到Nginx的欢迎界面。 PS:如果还是无法访问，需要把你的防火墙关闭(vagrant创建的虚拟机的root密码默认为vagrant)，`sudo systemctl stop firewalld`

💡: 如果需要转发多个端口，可以写多行。

```ruby
config.vm.network :forwarded_port, guest: 80, host: 8080
config.vm.network :forwarded_port, guest: 81, host: 8081
```


### 私有网络

+ 为虚机手工指定一个 ip 地址，通过这个 ip 实现宿主机和虚机之间的通讯；
+ 并且只能通过宿主机访问到虚机；
+ 如虚机做了一个 webserver，但是这个服务只能通过宿主机访问

```ruby
# Create a private network, which allows host-only access to the machine
# using a specific IP.
config.vm.network "private_network", ip: "192.168.33.10"
```
+ private_network 声明为私有网络
+ 后面的 ip 参数，可以自定义 ip，宿主机可以根据这个 ip 访问虚机
+ 修改之后 执行 reload
+ 在进入虚机使用 ifconfig 查询：

```bash
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.33.10  netmask 255.255.255.0  broadcast 192.168.33.255
```

其中 eth1 网卡就是在配置文件中设置的私有网络的地址


## 公有网络

+ 可以将虚机配置成在同一网络下，其他设备可以直接访问的虚机（上面的服务）

+ 将配置文件中以下配置打开：

```ruby
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

```

+ 执行 reload
+ 选择上网方式：

[image.png](http://qiniu.jiiiiiin.cn/7O5zAq.png)

+ ssh 到虚机，使用 ifconfig 查询当前虚机网络
+ 其中 eth1 就是虚机在局域网络中的 ip 地址，这个 ip 地址（TODO 是通过路由器自动分配的地址）


## Plugins


### scp

![Text](http://qiniu.jiiiiiin.cn/ReusSX.png)

+ 使用参考：https://coding.imooc.com/lesson/189.html#mid=11636





## VirtualBox

> [Text](https://wenku.baidu.com/view/8765d00403d8ce2f006623f7.html)
> [VirtualBox
> 的設定](https://www.youtube.com/watch?v=Nwsx6X_GKKE&list=PLSBXWUHUonqgr56bXPNTY3M2YgLR-84rn&index=3)

```bash
windows7 镜像下载：https://www.unyoo.com/209.html

```






