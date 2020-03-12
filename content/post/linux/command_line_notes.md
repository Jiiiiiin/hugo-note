---
title: "Shell 基础学习"
date: 2020-02-24T16:15:07+08:00
draft: true
---
 记录 shell 的一些基础知识
<!--more-->

 
<!-- vim-markdown-toc GFM -->

* [shell](#shell)
* [进入和推出 shell](#进入和推出-shell)
* [SSH](#ssh)
    * [-X](#-x)
    * [scp](#scp)
    * [sftp](#sftp)
    * [服务器公钥交换](#服务器公钥交换)
    * [SSDH服务管理](#ssdh服务管理)
    * [rsync 远端同步](#rsync-远端同步)
* [命令行 Command Line](#命令行-command-line)
    * [Shell Definition](#shell-definition)
    * [Available Shells in Linux](#available-shells-in-linux)
    * [Shell Prompt](#shell-prompt)
    * [Carriage Return (CR)](#carriage-return-cr)
* [Command Line Components](#command-line-components)
* [Internal Field Separator (IFS)](#internal-field-separator-ifs)
* [A Command Line Format](#a-command-line-format)
* [Character Type in Command Line](#character-type-in-command-line)
    * [常用的元字符 Frequently Used Meta Characters](#常用的元字符-frequently-used-meta-characters)
* [引用  Quoting Usage](#引用--quoting-usage)
    * [Escaping( \ ):](#escaping--)
    * [Hard Quoting( '' ):](#hard-quoting--)
    * [Soft Quoting( "" ):](#soft-quoting--)
        * [Exception in Soft Quoting](#exception-in-soft-quoting)

<!-- vim-markdown-toc -->

## shell

> [1.RHEL/CENTOS BASH shell基礎教學](https://www.youtube.com/watch?v=7Yu1c2-cYGg&list=PLSBXWUHUonqg5CC9YhDGVDZRYkRpGerNd)


+ shell 是一個程式，負責解譯及執行使用者所下達.的指令

    作为翻译器，需要做的就是，找到执行的指令的位置、翻译变量、重组指令、将指令送达到内核、接收响应、回显到
    STDOUTPUT
+ 為使用者處理輸入、輸出及系統的錯誤訊息顯示 standard input， standard output and standarderror ）
![Text](http://qiniu.jiiiiiin.cn/rcf2vf.png)
+ 啓動時讀取特殊的起始檔案（ startup files ）用來設定使用者個人所制訂的環境變數與預設變數（ environment variables and predefined variables ）
+ SHELL構成使用者指令操作環境

## 进入和推出 shell

+ 退出 shell，以下 3 种做法都是相同的；
```bash
$exit
$logout
Ctrl-d
```
+ 切换 shell

```bash
# 切换用户，相当于开了另外一个 shell 即开了一个新进程，启动的是一个 login
shell，如果这里不带一个 `-` 那就相当于只改变了uid 和 gid ，环境变量设定还是上一个用户的设定；
# 所以最佳实践在进行用户切换时候都加上dash 符号；
$su - alice
# 切换管理员 
$su -
# 切换 shell 类型
$tcsh

```
+ 查看当前的 shell 类型 `echo $SHELL`

## SSH
> [Linux远程管理 - SSH、VNC
> [LinuxCast视频教程]](https://www.youtube.com/watch?v=YK_orcjzfdk&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=33)

![Text](http://qiniu.jiiiiiin.cn/lSb4va.png)
+ jerry 第一次连接 SSHD 应用时候，应用会下发公钥到 jerry ，jerry
  将该公钥和远端主机信息一起保持在 know_hosts 文件
+ 协商一个对称加密秘钥下发到 jerry，之后的通信都处于对称加密过程
+ jerry 以 ssh 客户端连接，发出的指令是在远端 jack 的 shell 中解析执行；
+ 在每次连接 SSHD 都会下发公钥，jerry 的 ssh
  客户端会对远程主机和本地对应公钥和其进行对比，如果对比不上就会提示用户；
  ![Text](http://qiniu.jiiiiiin.cn/V6nvx9.png)
  解决方式就是到主机（本机）的 know_hosts 文件把对应的主机已存在那条记录删除，再重试；

+ 连接认证方式可以是公私钥方式或者是用户名方式；

### -X

好处就是可以直接和远端主机进行视窗交互；
![Text](http://qiniu.jiiiiiin.cn/ZEBnyO.png)
![Text](http://qiniu.jiiiiiin.cn/mrE44F.png)


### scp

![Text](http://qiniu.jiiiiiin.cn/rUEMnh.png)
+ 主机跟一个冒号代表传送文件到远端主机的家目录；
+ 冒号后面跟目录表示将档案上传到远程主机对应目录，需要注意的是，你标注的登陆用户身份要具有权限访问上传的路径
+ 第三条指令是使用 root 身份将远端主机的 xyz 文件下载到本机的 opt 目录下；

    注意不跟用户名就标识使用当前主机的用户去连接远端同名用户，其实 ssh
也是一样的用法针对这个；

### sftp

> [6.RHEL/CENTOS BASH shell 基礎教學](https://www.youtube.com/watch?v=8n9F7Bjv9PU&list=PLSBXWUHUonqg5CC9YhDGVDZRYkRpGerNd&index=6)

![Text](http://qiniu.jiiiiiin.cn/oxVgLv.png)

### 服务器公钥交换

意义为了能穿透管理服务器，设置公钥是很重要的；

> [6.RHEL/CENTOS BASH shell 基礎教學](https://www.youtube.com/watch?v=8n9F7Bjv9PU&list=PLSBXWUHUonqg5CC9YhDGVDZRYkRpGerNd&index=6F)

![Text](http://qiniu.jiiiiiin.cn/NRViu3.png)
![Text](http://qiniu.jiiiiiin.cn/D0Grhz.png)

+ ssh-copy-id 指令使用

![Text](http://qiniu.jiiiiiin.cn/xElfQE.png)
![Text](http://qiniu.jiiiiiin.cn/DDbhlK.png)

### SSDH服务管理

![Text](http://qiniu.jiiiiiin.cn/s6FVee.png)
![Text](http://qiniu.jiiiiiin.cn/3V5jAM.png)

+ 配置文件

```bash
[vagrant@localhost ssh]$ ls -ld /etc/ssh/sshd_config
-rw-------. 1 root root 3916 Jun  1  2019 /etc/ssh/sshd_config


# 配置是否允许 root 远程登陆，默认允许
#PubkeyAuthentication yes

# 是否允许用户名密码登陆
# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication no
```

修改完成配置之后，重启服务即可生效：`service restart sshd`

+ 更换金钥

![Text](http://qiniu.jiiiiiin.cn/toDVKx.png)
![Text](http://qiniu.jiiiiiin.cn/iPHlWW.png)
![Text](http://qiniu.jiiiiiin.cn/FLC4yS.png)

删除 sshd 服务的所有金钥，之后重启即可；

这个更换过程会影响之前连线过的客户端主机，对应主机需要到家目录 `.ssh`
目录下修改`known_hosts`类型文件，删除远程主机（更换金钥的主机）的公钥记录即可；

![Text](http://qiniu.jiiiiiin.cn/70JKLK.png)
修改之后重新连接即可重新添加远程主机 sshd 公钥；

### rsync 远端同步


> https://www.youtube.com/watch?v=Uj5TfMuU6mU&list=PLSBXWUHUonqg5CC9YhDGVDZRYkRpGerNd&index=8

![Text](http://qiniu.jiiiiiin.cn/SsLs3J.png)
![Text](http://qiniu.jiiiiiin.cn/iSkH9H.png)
支持匿名备份即无需登录交互的情况下完成备份；

![Text](http://qiniu.jiiiiiin.cn/TLWvzh.png)

+ 常用 `-a` 递归备份所有文档

+ 远端同步流程

![Text](http://qiniu.jiiiiiin.cn/GpwOmM.png)

+ `-z` 使得在传送之前对文档进行压缩，上传完成之后会进行解压缩，保证专属速率
+ `-e` 后面紧跟执行命令，一般为 ssh，示例就是使用远端主机的 peter
  身份登录，接着跟远端主机需要备份的目录 `/remote/dir` 备份到当前主机的
  `this/dir` 目录；
+ 这个命令强的地方就在于不会进行全量的备份，而是会先进行比对，之后将不同的地方进行备份；
+ 将本机的文档备份到远程主机示例：`rsync -a /srv/papers 192.168.0.250:/opt/backup`，记得先使用`ssh-copy-id` 将本机的 ssh 公钥上传到远端主机；
+ 如果本地文档中有修改，在执行一次对应命令 `rsync -a /srv/papers 192.168.0.250:/opt/backup`即可完成下一次同步；
+ 另外上面命令中的 `-e ssh` 这几个字符可以省略，默认就是使用 ssh 完成连接
+ NFS 示例 TODO
+ 示例中的 NFS 是将本地的 log 文档同步到远端的 NFS 对应目录；
+ 建议不要使用 `*`进行匹配



## 命令行 Command Line

> [Command Line](https://www.slideshare.net/kennychennetman/linux-chap-00-shell)

![Text](http://qiniu.jiiiiiin.cn/Uew9i5.png)

Everything typed between Shell Prompt and Carriage Return.

在 shell 提示符和回车间的内容就是命令行内容；

系统 shell 都是以一行为一个处理单元，所以叫命令行；

这里的一行是指 shell prompt 和 carriage return 之间的字符；
### Shell Definition

Command interpreter:

Issue commands from user to system

从用户向系统发布命令;

Display command results from system to user

从系统向用户显示命令结果

### Available Shells in Linux

```bash
[vagrant@localhost ~]$ cat /etc/shells
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
```

### Shell Prompt
Function;

Telling the user: 
You can type command now! 

Style:
+ Super User: #
+ Regular User: $ or >

prompt提示用户目前处于可交互模式；

### Carriage Return (CR)
+ Function:
Telling the system: You can run command now! 
+ Generated by: `<Enter>`

## Command Line Components

+ A Command (must present):
What to do?
+ Options (zero or more): 
How to do?
+ Arguments (zero or more):
Which to do with?

## Internal Field Separator (IFS) 
+ Function:
To separate command line components. 
+ Speak in general:
To cut a command line into words(fields). 
+ Generated by:

```
<Space>
<Tab>
<Enter> (*note: CR also)
```

IFS就是用来切割命令为不同的快（filed）的标记；

一般都是用空格键；
## A Command Line Format

`Command<IFS>[Options…]<IFS>[Arguments…]`

## Character Type in Command Line 

Literal Character:
Plain text, no function
```
123456 abcdefg
```

Meta Character:
Reserved with functions

文字字符：
纯文本，无功能

元字符：
保留功能

### 常用的元字符 Frequently Used Meta Characters

![Text](http://qiniu.jiiiiiin.cn/RTPTM6.png)

## 引用  Quoting Usage
Purpose:
Disable the functions of Meta Characters.

Quoting Method
### Escaping( \ ):
Disable meta character following backward slash by each.
+ Example:

```bash
\$
\(
\\
\<newline>
```

### Hard Quoting( '' ):
Disable all meta characters within single quotes.

Example:

'...$...(...)...'


### Soft Quoting( "" ):
Disable some meta characters within double quotes. .
Example:


"...$...(...)..."

#### Exception in Soft Quoting
Reserved functions: 

```bash
$ : substitute
\ : escape
` : command substitute  
! : history
```




