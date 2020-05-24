---
title: "Linux_package_management"
date: 2020-02-27T20:19:55+08:00
draft: true
---

Linux 包管理相关学习记录。
<!--more-->


<!-- vim-markdown-toc GFM -->

* [文件比对及数位摘要](#文件比对及数位摘要)
    * [cmp指令](#cmp指令)
    * [diff指令](#diff指令)
    * [sum/md5sum/sha256sum/sha512sum](#summd5sumsha256sumsha512sum)
* [软件开发阶段 Software Development Stages](#软件开发阶段-software-development-stages)
* [程序库的链接方式 Library Linking Method](#程序库的链接方式-library-linking-method)
* [库管理 Library Management](#库管理-library-management)
* [Tarball](#tarball)
    * [源代码安装 Tarball Installation Procedure](#源代码安装-tarball-installation-procedure)
* [RPM Redhat Package Management](#rpm-redhat-package-management)
    * [RPM 安装和更新 RPM Installing / Upgrading](#rpm-安装和更新-rpm-installing--upgrading)
        * [RPM 选项 Common options:](#rpm-选项-common-options)
    * [RPM移除 RPM Uninstallation](#rpm移除-rpm-uninstallation)
* [RPM 查询相关 RPM Querying](#rpm-查询相关-rpm-querying)
* [RPM 验证相关 RPM Verifying](#rpm-验证相关-rpm-verifying)
    * [RPM Signatures](#rpm-signatures)
* [YUM](#yum)
* [Debian 下的包管理](#debian-下的包管理)
* [仓库设置 Repository Settings](#仓库设置-repository-settings)
* [光盘搭建 yum 源](#光盘搭建-yum-源)

<!-- vim-markdown-toc -->

> [Chapter 9 Package Management](https://www.slideshare.net/kennychennetman/chap-09-pkg)

> [輕鬆學習 Linux 軟體管理-數位簽章及加密法-檔案比對及數位摘要](https://www.youtube.com/watch?v=MwrAgHedUNs&list=PLb6Q-5c_2awoq2Wk2MiUCtIqGmR_zvMDz)


## 文件比对及数位摘要

### cmp指令
cmp命令 用来比较两个文件是否有差异。当相互比较的两个文件完全一样时，则该指令不会显示任何信息。若发现有差异，预设会标示出第一个不通之处的字符和列数编号。
```bash
[vagrant@localhost test]$ cp test.java test1.java
[vagrant@localhost test]$ cmp test.java test1.java
[vagrant@localhost test]$ vi test.java
[vagrant@localhost test]$ cmp test.java test1.java
test.java test1.java differ: byte 988, line 22

```

+ 当发现第一个不同的地方的时候就会停止比对，并回显不同的信息，无论文档之后还有没有其他的不同
+ cmp是一个一个字符的进行比较

### diff指令

TODO 添加链接地址
> [Linux 基础知识和常用命令](id)

### sum/md5sum/sha256sum/sha512sum

用来比较二进制类型文件，通过演算法来比较两个文件是否不同；

![Text](http://qiniu.jiiiiiin.cn/1N16Vz.png)
![Text](http://qiniu.jiiiiiin.cn/yFUMMn.png)

![Text](http://qiniu.jiiiiiin.cn/qaObHr.png)



## 软件开发阶段 Software Development Stages

+ Source Code
+ Compilation
+ Binary Code
+ Process

![Text](http://qiniu.jiiiiiin.cn/eIGmX9.png)
相同的源代码使用编译器（如 gcc）按照需求变异成不同的平台架构的二进制程序；

之后就可以执行这个二进制程序，得到进程；

![Text](http://qiniu.jiiiiiin.cn/E1GD1e.png)


## 程序库的链接方式 Library Linking Method
+ Static
     - Enclosed during the compilation
     - Portable
     - Duplicate loading

     静态方法就是在编译程序的时候，将依赖库直接编译（或者说依赖的函数们）到输出的二进制程序中；

     优势在于容易移植；

     劣势是在于，如果公用一个函数（应该是在 c
     环境），那么如果使用静态的方式编译出来的程序，每一个执行进程这个函数都要占用各自的一部分内存。
     但是动态的方式，这个所有依赖这个函数的程序，都会共享唯一的一个函数所占用的那一部分内存；

+ Dynamic
     - Only information linked after compiled 
     - Environment dependent
     - Load once and share

    而动态的链接方式，在编译的时候，只会将依赖的函数原信息放在二进制程序中；

## 库管理 Library Management

+ ldd command
    - Shows the libraries needed by the command 

    如果 ldd 检出有某个 library
    不存在本机，那么这个二进制程序应该就不能跑，需要把缺失的库装好；
    所以用这个命令可以检测一个动态库所依赖的库是否缺失；


```bash
[vagrant@localhost ~]$ file /bin/ls
/bin/ls: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=aaf05615b6c91d3cbb076af81aeff531c5d7dfd9, stripped
[vagrant@localhost ~]$ ldd /bin/ls
    # 已经存在于内存就没有路径 
	linux-vdso.so.1 =>  (0x00007ffea2dee000)
    # .1是声明这个库的版本 
	libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f4819447000)
	libcap.so.2 => /lib64/libcap.so.2 (0x00007f4819242000)
	libacl.so.1 => /lib64/libacl.so.1 (0x00007f4819039000)
	libc.so.6 => /lib64/libc.so.6 (0x00007f4818c6b000)
	libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f4818a09000)
	libdl.so.2 => /lib64/libdl.so.2 (0x00007f4818805000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f481966e000)
	libattr.so.1 => /lib64/libattr.so.1 (0x00007f4818600000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f48183e4000)
```

下面就是一个程序缺少依赖的函数库，查询的结果：

![Text](http://qiniu.jiiiiiin.cn/IWI315.png)


+ ltrace command
    - Traces the libraries running results
+ /etc/ ld.so.cache
    - Stores the run time library paths

    这个文件会记录当前系统中存在的函数有些什么；

    程序在执行的时候，会去调用这个文档中定义的函数的时候会去这个文档查询；

    这个文件是不能被直接修改，可以使用下面这个配置文件去修改，以加入，新增的函数；

+ /etc/ld.so.conf
    - Location of non一standard library directories 
    
    如果新增的函数不是放在标准目录，那就必须要通过这个配置文件，将非 标准函数库（或者说新增自定义函数库）进行声明（位置声明）

    标准函数库路径：TODO

+ ldconfig
    - Updates or shows library paths

    这个命令可以将上面的配置文件声明的和标准的函数库，更新到/etc/ld.so.cache
 
+ LD_LIBRARY_PATH

    在没有管理员权限的时候临时引用动态库的方式；

## Tarball
+ Package archive
    - Software sources
    - Makefile

        make 类似 shell script 的另外一种可以做自动化的脚本语言；

        markfile 可以进行自动编译；
        
        里面放置的就是类 gcc 编译源代码的编译指令；

    - Configuration

        prel 或 shell 脚本来编写；

        用于检测主机；

        用于检测环境中程序依赖的库、环境等是否满足要求，如果不满足则拒绝；

        运行完毕之后，会根据当前的环境生成对应的 markfile；

        也就是说一般而言源代码安装，不会提供默认的 markfile 而是通过这个
        configuration 来检测之后，根据环境动态生成；

        这样的好处就在于可以进行预检测；


    - Documentation
     
        一般存放版权、安装声明（选项）

所谓 Tarball 就是将以上这些用于编译程序的文件包装起来的压缩包；

### 源代码安装 Tarball Installation Procedure 
+ Download
    + wget http://some.where/tarball一version.tgz 
+ Unpack
    - tar 一zxvf tarball一version.tgz
+ Change working directory
    - cd tarball一version
+ View document
    - less README
    - less INSTALL


安装过程 Tarball Installation Procedure 
+ Configure
    - ./configure
+ Make
    - make

    只要完成上面的检测并生成 markfile 之后就可以直接使用 make 命令；

    跑的过程就是对源代码进行编译，使用 gcc 或其他；

    编译完成之后就得到一个二进制的程序，但是程序是在当前目录的；

    makefile 类似 ANT 也是用一系列的 target 来进行任务的排列，默认如果 make
    不传递任务 id 就会执行 markfile的第一个任务；

+ Install
    - sudo make install

    make 的安装任务，将程序安装到适合的位置，并设置好对应的权限等；

    一般而言这一步需要使用 sudo，因为需要权限去执行一些操作；

    而前面的两个步骤***不要使用 sudo 去做，安全起见***。

![](http://qiniu.jiiiiiin.cn/EojQmF.png)


![](http://qiniu.jiiiiiin.cn/1z1bIM.png)

源码包一定要指定安装位置；

![](http://qiniu.jiiiiiin.cn/3q6e42.png)
![](http://qiniu.jiiiiiin.cn/gRoJGU.png)

![](http://qiniu.jiiiiiin.cn/ZFKs09.png)

![](http://qiniu.jiiiiiin.cn/tVKj7n.png)

## RPM Redhat Package Management 


> https://www.youtube.com/watch?v=0JhTo0mCGyY&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=29

![](http://qiniu.jiiiiiin.cn/KHziFi.png)

RPM在安装的时候会检测依赖，如果缺失默认拒绝安装；

在删除一个程序的时候，也会检测是否存在上层依赖，如果存在也会拒绝删除；

+ Tarball + SPEC + Patches

    在 tarball 的基础之上，再加上一个资料库；

    外加归个档和修补档 

![Text](http://qiniu.jiiiiiin.cn/O1e0aQ.png)

source RPM，其实就是Tarball+SPEC 的一个打包档案；

可以将其解析成原文件，在通过rpmbuild 打包出二进制的 rpm 包；

source RPM，其实就是Tarball+SPEC 的一个打包档案；

可以将其解析成原文件，在通过rpmbuild 打包出二进制的 rpm 包；


+ Use rpmdb to store package information;
    一般规格档（SPEC）会定义下面的东西：

    - Header
    - Installation date
    - File path
    - Dependency
    - Verification

### RPM 安装和更新 RPM Installing / Upgrading

![](http://qiniu.jiiiiiin.cn/izdZ5H.png)

![](http://qiniu.jiiiiiin.cn/XlSYim.png)
+ Install:
rpm -i package-version.rpm

必须是全新安装

+ Freshen (old version installed):
rpm -F package-version.rpm

必须要有一个旧版本存在；

+ Upgrade (removes old version first):
rpm -U package-version.rpm

自动识别上面两个命令；

约定安装位置：
![](http://qiniu.jiiiiiin.cn/ldQ6bS.png)
#### RPM 选项 Common options:
+ -v : verbose

显示安装详情；

+ -h : prints procedure percentage

一般和-v 搭配显示安装进度；

+ --test : test only

测试安装；

+ --force : ignore error

忽略错误，强制安装；
+ --nodeps : skips dependency checking (Risk!)

忽略相依性检查，RPM 默认在检查到缺失依赖就不会进行安装；

检查依赖请看上面的资料库一节；

### RPM移除 RPM Uninstallation
+ Uninstall:
rpm -e package

    移除程序时候也会进行相关性依赖的检查，如果存在上层依赖（依赖这个待删除的程序），rpm
也会禁止删除；

+ Common options: 

    --nodeps : skips dependency checking

## RPM 查询相关 RPM Querying

yum 不能实现 rpm 已经安装包的查询，所以 rpm 的查询功能是常用的；

![](http://qiniu.jiiiiiin.cn/Ax3NsW.png)


+ Query package:

    rpm -q package

    查询已经装好的软件的信息；


    rpm -qp package-version.rpm 

    查询未安装的软件包的信息；


+ Common options:
    -a : all installed packages

        -qa 查询已经装好的所有软件的信息 

    -f file : which package owns the file

        -qf 制定一个待查询的文件，可以得到这个文件是由哪个安装包产生的；

    -i : package information

    -l : package files

        -ql 能够列出软件包安装的所有文件

    -d : documentation files

        -ql 是列出文档和配置文件，-qd 只列出文档

    -c : configuration files

        -ql 是列出文档和配置文件，-qc 只列出配置文件 


## RPM 验证相关 RPM Verifying

![](http://qiniu.jiiiiiin.cn/IjwvPO.png)

+ Verify package:

    rpm -V package
+ Verification results:

    验证结果的输出结果字段，如果出现下面的字段，就表示程序的某一个项被修改过：

    - S : size
    - 5 : MD5 checksum
    - M : permission
    - U/G :user l group
    - T : modification time
    - L : symbolic link
    - D : device number
### RPM Signatures
+ Import public key :
rpm --import /path/to/RPM-GPG-KEY

    第一步要引入前面的厂商的公钥；

+ Verify package signature : 
rpm --checksig package-version.rpm

    验证对应的包是否验签无误；


## YUM

> https://www.youtube.com/watch?v=nEPUbD4Q-t4&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=30

+ Yellowdog Updater, Modifier 
    - Advanced front一end tools for RPM
    - All packages stored in repositories on network 
    - Automatic dependency resolving

![](http://qiniu.jiiiiiin.cn/q9ATLK.png)

![](http://qiniu.jiiiiiin.cn/kqmEsN.png)

主机可以配置多个站点，在安装过程中，会逐个查找不同的站点仓库，直到找到软件包为止；


+ Syntax:
    - yum install package ...
    - yum update [package ..].
    - yum check一update
    - yum remove package ..


![](http://qiniu.jiiiiiin.cn/R044HE.png)

在执行输出的时候需要小心，他会把软件的依赖也删除；


## Debian 下的包管理

![Text](http://qiniu.jiiiiiin.cn/4riZQo.png)

![Text](http://qiniu.jiiiiiin.cn/3IbMTU.png)

底层都是对 tarball 的包装；

## 仓库设置 Repository Settings
+ yum
    - /etc/yum.repos.d/* .repo 

    yum 可以有多个设置，一般一个仓库源设置一个配置文件；

+ apt-get
    - /etc/apt/sources.list

    apt-get 只有一个配置文件；


![](http://qiniu.jiiiiiin.cn/ECdXGN.png)


> https://www.imooc.com/video/8940

![](http://qiniu.jiiiiiin.cn/ep24jN.png)
![](http://qiniu.jiiiiiin.cn/ftKx4T.png)


## 光盘搭建 yum 源

https://www.imooc.com/video/8941

