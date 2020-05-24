---
title: "Docker_data_notes"
date: 2020-04-12T22:09:50+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [Container Layer](#container-layer)
    * [Volume 类型](#volume-类型)
* [Data Volume](#data-volume)
    * [创建容器指定volume](#创建容器指定volume)
* [Bind Mouting](#bind-mouting)

<!-- vim-markdown-toc -->

## Container Layer

![Text](http://qiniu.jiiiiiin.cn/f2kjsD.png)

+ container layer
  中写入的数据，只是“临时数据”，即如果容器被删除，那么在这一层之前写入的数据就会丢失；

+ 如果创建一个数据库的容器，那么就不能将数据存储在这一层

### Volume 类型

+ 受管理的data Volume ，由docker后台自动创建。
+ 绑定挂载的Volume ，具体挂载位置可以由用户指定。

## Data Volume

![Text](http://qiniu.jiiiiiin.cn/HR3JlA.png)

+ 使用volume机制将一个宿主机目录作为容器的持久层，来解决上面的问题

+ 基于本地文件系统的Volume。可以在执行Docker create或Docker run时，通过一v参数将主机的目录作为容器的数据卷。这部分功能便是基于本地文件系统的volume管理。
+ 基于plugin的Volume ，支持第三方的存储方案，比如NAS aws

### 创建容器指定volume

+ 对应Dockerfile中使用`VOLUME`指定 > [VOLUME 定义匿名卷](https://yeasy.gitbooks.io/docker_practice/image/dockerfile/volume.html)

> 之前我们说过，容器运行时应该尽量保持容器存储层不发生写操作，对于数据库类需要保存动态数据的应用，其数据库文件应该保存于卷(volume)中，后面的章节我们会进一步介绍 Docker 卷的概念。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 Dockerfile 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。


![Text](http://qiniu.jiiiiiin.cn/Eh0vdU.png)

+ 注意这里声明的这个路径是在容器中的路径，即让容器运行的时候会产生一些文件（这些文件由制作容器的开发者负责，将数据落到该目录下）
+ 这就是使用docker volume的第一步

> 这里的 /var/lib/mysql 目录就会在运行时自动挂载为匿名卷，任何向 /var/lib/mysql 中写入的信息都不会记录进容器存储层，从而保证了容器存储层的无状态化。当然，运行时可以覆盖这个挂载设置。比如：

![Text](http://qiniu.jiiiiiin.cn/L0WArN.png)

![Text](http://qiniu.jiiiiiin.cn/acIRql.png)

+ 建议在使用的时候，添加`-v
  CUSTOM_VOLUME_NAME`给上面第一步指定的匿名卷指定一个好记忆的名字

+ 这样就可以友好的定义volume，放置因为容器的删除而导致数据的丢失

![Text](http://qiniu.jiiiiiin.cn/ZSh2qY.png)


## Bind Mouting

+ 和data volume的区别在于

    - data volume需要在dockerfile中声明一个匿名卷

    - 而bind mouting不需要事先声明匿名卷

    - 只需要在运行容器的时候指定本地宿主机存储数据的目录和容器对应存储目录的一一对应关系：`-v /LOCAL_DIR:/CONTAINER_DIR`

    - bind
      mouting这种做法相当于是做一种"数据盘同步"，即无论是在宿主机修改了目录中的文件还是在容器中，另外一方都会得到同样的响应

+ 示例：将宿主机当前目录`$(pwd)`作为容器运行的nginx的服务器根目录

    ![Text](http://qiniu.jiiiiiin.cn/jEg8nv.png)

    这样做就方便了前端开发试试部署测试这样一个需求；

    ![Text](http://qiniu.jiiiiiin.cn/F8eget.png)

    如果使用vagrant来完成这个需求，如上图可以指定真实机的`./labs`目录映射到虚机，这样3个“系统”的目录就打通了

    使用这个功能可以模拟前端目前流行的hot reload的功能

