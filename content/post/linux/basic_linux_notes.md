---
title: "Linux 基础知识和常用命令"
date: 2020-02-20T11:37:17+08:00
tags: ["linux", "shell-cmd"]
categories: ["linux"]

---

Linux 基础知识和常用的 Linux 命令
<!--more-->


<!-- vim-markdown-toc GFM -->

* [日期相关](#日期相关)
* [date](#date)
* [进程相关](#进程相关)
    * [输出Shell本身的PID（ProcessID）](#输出shell本身的pidprocessid)
    * [netstat](#netstat)
    * [ps](#ps)
    * [watch](#watch)
* [数据相关 Data Stream](#数据相关-data-stream)
    * [文件描述符 File Descriptor (FD)](#文件描述符-file-descriptor-fd)
        * [标准文件描述符 Standard FD](#标准文件描述符-standard-fd)
    * [重定向 IO Redirection](#重定向-io-redirection)
    * [Device /dev/null](#device-devnull)
    * [管道符 Pipe Line](#管道符-pipe-line)
        * [tree Output Splitting](#tree-output-splitting)
    * [A Simple Command: echo](#a-simple-command-echo)
    * [grep](#grep)
    * [xargs](#xargs)
        * [分隔符](#分隔符)
        * [-0 参数与 find 命令](#-0-参数与-find-命令)
    * [cut](#cut)
    * [wc 文本统计](#wc-文本统计)
    * [sort 对文本进行排序](#sort-对文本进行排序)
    * [diff 文本比较](#diff-文本比较)
    * [tr 处理文本内容](#tr-处理文本内容)
    * [sed 检索替换](#sed-检索替换)
* [命令相关](#命令相关)
    * [witch](#witch)
* [目录相关](#目录相关)

<!-- vim-markdown-toc -->




TODO


## 日期相关

## date

+ 获取当前是今年的第几天

```bash
❯ date +%j
058
```

注意 date 的格式化输出选项前面需要加 `+`；




## 进程相关


### 输出Shell本身的PID（ProcessID） 

```
# 输出Shell本身的PID（ProcessID） http://www.tldp.org/LDP/abs/html/internalvariables.html#PROCCID
# $$ is the process ID (PID) of the script itself.

# $BASHPID is the process ID of the current instance of Bash. This is not the same as the $$ variable, but it often gives the same result.
echo $$

[vagrant@localhost ~]$ echo $$
3663
[vagrant@localhost ~]$ ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S  1000  3663  3662  0  80   0 - 29126 do_wai pts/0    00:00:00 bash
```

### netstat

用来打印Linux中网络系统的状态信息，可让你得知整个Linux系统的网络情况。

```bash
-a或--all：显示所有连线中的Socket；
-A<网络类型>或--<网络类型>：列出该网络类型连线中的相关地址；
-c或--continuous：持续列出网络状态；
-C或--cache：显示路由器配置的快取信息；
-e或--extend：显示网络其他相关信息；
-F或--fib：显示FIB；
-g或--groups：显示多重广播功能群组组员名单；
-h或--help：在线帮助；
-i或--interfaces：显示网络界面信息表单；

-l或--listening：显示监控中的服务器的Socket；
-t或--tcp：显示TCP传输协议的连线状况；
-n或--numeric：直接使用ip地址，而不通过域名服务器；
-p或--programs：显示正在使用Socket的程序识别码和程序名称；

-M或--masquerade：显示伪装的网络连线；
-N或--netlink或--symbolic：显示网络硬件外围设备的符号连接名称；
-o或--timers：显示计时器；
-r或--route：显示Routing Table；
-s或--statistice：显示网络工作信息统计表；
-u或--udp：显示UDP传输协议的连线状况；
-v或--verbose：显示指令执行过程；
-V或--version：显示版本信息；
-w或--raw：显示RAW传输协议的连线状况；
-x或--unix：此参数的效果和指定"-A unix"参数相同；
--ip或--inet：此参数的效果和指定"-A inet"参数相同。
```

+ 查询 t（cp）协议连线正在 l（listening）的服务 p（rogams）用 ip 号码
  n（umeric）显示

第一个栏位显示协议，第三栏显示 ip和端口，最后连个显示监听状态和进程号和程序名；

```bash
[vagrant@localhost ~]$ netstat -ltnp
(No info could be read for "-p": geteuid()=1000 but you should be root.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -
```





### ps

```bash
# 采用详细的格式来显示程序状况。
ps -l
```

### watch
可以将命令的输出结果输出到标准输出设备，多用于周期性执行命令/定时执行命令
```bash
# 每间隔 1 秒执行一次对应的命令 
watch -n1 ifconfig
```


## 数据相关 Data Stream


> [data stream](https://www.slideshare.net/kennychennetman/chap-01-io)


### 文件描述符 File Descriptor (FD)
+ Processes use File Descriptors to input or output (I/O) data with system
+ Each process has 256 FDs
+ The first 3 FDs are standard

    - 0 : Standard Input (STDIN)
    - 1 : Standard Output (STDOUT)
    - 2 : Standard Error Output (STDERR)

#### 标准文件描述符 Standard FD
By default, each standard FD is connected to an I/O device:
+ STDIN : Keyboard
+ STDOUT : Screen
+ STDERR : Screen

![Text](http://qiniu.jiiiiiin.cn/G5xor7.png)


### 重定向 IO Redirection

> [Linux多命令协作：管道及重定向](https://www.bilibili.com/video/av4051905?p=19)

![Text](http://qiniu.jiiiiiin.cn/XUXOCn.png)

Standard FD can be changed in command line:

+ STDIN : < file
+ STDOUT : > file
+ STDERR : 2> file

![](http://qiniu.jiiiiiin.cn/0sOoc0.png)

+ Output Appending
Keep the existing content in target file by using >> :

```bash
$ find /etc >/dev/null 2>> std.out
```

![Text](http://qiniu.jiiiiiin.cn/orZ0bW.png)


### Device /dev/null
Keep the STDERR only: 

```bash
$ find /etc > /dev/null
```

### 管道符 Pipe Line
> [管道及重定向](https://www.youtube.com/watch?v=oJHQ2Mubpfc&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=17)

Connect STDOUT of left command to STDIN of right command:

`cmd1 | cmd2`

![Text](http://qiniu.jiiiiiin.cn/LBeFbl.png)

用也可以用一句话来概括把前一个命令原本要输出到屏幕的标准正常数据当作是后一个命令的标准输入。


Combine STDERR into STDOUT in pipe line:

```bash
$ cmd1 2>&1 | cmd2
```
![Text](http://qiniu.jiiiiiin.cn/PLtBEU.png)

+ 示例

这个管道符就像一个法宝，我们可以将它套用到其他不同的命令上，比如用翻页的形式
查看/etc 目录中的文件列表及属性信息（这些内容默认会一股脑儿地显示到屏幕上，根本看不清楚）：

```bash
[root@linuxprobe ~]# ls -l /etc/ | more
total 1400
drwxr-xr-x. 3 root root 
97 Jul 
10 17:26 abrt
-rw-r--r--
. 1 root root 
16 Jul 
10 17:36 adjtime
-rw-r--r--
. 1 root root 1518 Jun 
7 2013 aliases
-rw-r--r--
. 1 root root 12288 Jul 
10 09:38 aliases.db
drwxr-xr-x. 2 root root 
49 Jul 
10 17:26 alsa
drwxr-xr-x. 2 root root 4096 Jul 
10 17:31 alternatives
-rw-------
```
#### tree Output Splitting
Tap an output copy to a file by using command tee :

![Text](http://qiniu.jiiiiiin.cn/AE0Qqo.png)

```bash
$ cmd1 | tee file | cmd2
$ cmd1 | tee -a file | cmd2
```
tee在中间 cp 一份 output 输出（覆盖和追加）到一个文件中；
两个 cmd 之间的工作不受影响；

将输出到屏幕的东西，导一份到日志中：

`[vagrant@localhost ~]$ find /etc 2>&1 | tee log`

### A Simple Command: echo
Function:
To display all arguments to STDOUT(screen), plus an ending <newl ine> character.

Major options:
+ -n .: disable the trailing <newline>
+ -e : enable interpretation of escapes (\\)

使用-e选项时，若字符串中出现以下字符，则特别加以处理，而不会将它当成一般文字输出：

```
\a 发出警告声；
\b 删除前一个字符；
\c 不产生进一步输出 (\c 后面的字符不会输出)；
\f 换行但光标仍旧停留在原来的位置；
\n 换行且光标移至行首；
\r 光标移至行首，但不换行；
\t 插入tab；
\v 与\f相同；
\\ 插入\字符；
\nnn 插入 nnn（八进制）所代表的ASCII字符；
```

```sh
#! /bin/bash
show_usage () {
    echo Usage:
    echo -e "\t$0 file"
}
```

### grep

> [bash 命令一览](https://linhaorong.top/blog/linux/commands/)

grep命令用来在文件中搜索指定文本。

![Text](http://qiniu.jiiiiiin.cn/zjJoB6.png)

```bash
[vagrant@localhost ~]$ grep 'vagrant' < /etc/passwd
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
[vagrant@localhost ~]$ cat /etc/passwd | grep 'vagrant'
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
```



### xargs
Change the STDIN to be as argument by using xargs :

```bash
$ cmd1 | xargs cmd2
```

![Text](http://qiniu.jiiiiiin.cn/IGEODc.png)

> [xargs 命令教程](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)

xargs命令的作用，是将标准输入转为命令行参数。

+ 背景

Unix 命令都带有参数，有些命令可以接受"标准输入"（stdin）作为参数。

如： `$ cat /etc/passwd | grep root` 因为grep命令可以接受标准输入作为参数，所以上面的代码等同于下面的代码 `$ grep root /etc/passwd` ，但是，大多数命令都不接受标准输入作为参数，只能直接在命令行输入参数，这导致无法用管道命令传递参数。举例来说，echo命令就不接受管道传参。

如：`$ echo "hello world" | echo` 上面的代码不会有输出。因为管道右侧的echo不接受管道传来的标准输入作为参数。

所以在这种情况下就可以使用 `xargs` 命令：

```bash
$ echo "hello world" | xargs echo
hello world
```

上面的代码将管道左侧的标准输入，转为命令行参数hello world，传给第二个echo命令。

xargs的作用在于，大多数命令（比如rm、mkdir、ls）与管道一起使用时，都需要xargs将标准输入转为命令行参数。

```bash
$ echo "one two three" | xargs mkdir
```

上面的代码等同于mkdir one two three。如果不加xargs就会报错，提示mkdir缺少操作参数。


```bash
[vagrant@localhost ~]$ cal|xargs echo| awk '{print $NF}'
31
```
获得当月的最后一天；


+ 其他

大多数时候，xargs命令都是跟管道一起使用的。但是，它也可以单独使用。

```bash
$ xargs
# 等同于
$ xargs echo
```

如：

```bash
$ xargs find -name
"*.txt"
./foo.txt
./hello.txt
```

上面的例子输入xargs find -name以后，命令行会等待用户输入所要搜索的文件。用户输入"*.txt"，表示搜索当前目录下的所有 TXT 文件，然后按下Ctrl d，表示输入结束。这时就相当执行find -name *.txt。


#### 分隔符

默认情况下，xargs将换行符和空格作为分隔符，把标准输入分解成一个个命令行参数。


```bash
$ echo "one two three" | xargs mkdir
```

上面代码中，mkdir会新建三个子目录，因为xargs将one two three分解成三个命令行参数，执行mkdir one two three。

***-d参数可以更改分隔符。***

```bash
$ echo -e "a\tb\tc" | xargs -d "\t" echo
a b c
```

上面的命令指定制表符\t作为分隔符，所以a\tb\tc就转换成了三个命令行参数。echo命令的-e参数表示解释转义字符。



#### -0 参数与 find 命令

由于xargs默认将空格作为分隔符，所以不太适合处理文件名，因为文件名可能包含空格。

find命令有一个特别的参数-print0，指定输出的文件列表以null分隔。然后，xargs命令的-0参数表示用null当作分隔符。

```bash
$ find /path -type f -print0 | xargs -0 rm
```

上面命令删除/path路径下的所有文件。由于分隔符是null，所以处理包含空格的文件名，也不会报错。

还有一个原因，使得xargs特别适合find命令。有些命令（比如rm）一旦参数过多会报错"参数列表过长"，而无法执行，改用xargs就没有这个问题，因为它对每个参数执行一次命令。

```bash
$ find . -name "*.txt" | xargs grep "abc"
```

上面命令找出所有 TXT 文件以后，对每个文件搜索一次是否包含字符串abc。




> [其他参数](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)





### cut

![Text](http://qiniu.jiiiiiin.cn/ZIAEWz.png)

+ 截取制定数据的某个栏位

`cat /etc/passwd | cut -d ':' -f 1`

### wc 文本统计 

![Text](http://qiniu.jiiiiiin.cn/JKHtvs.png)

### sort 对文本进行排序

![Text](http://qiniu.jiiiiiin.cn/qzKbik.png)
+ 命令sort -u可以用以删除重复行；
+ 命令uniq用以删除重复的相邻行


### diff 文本比较

![Text](http://qiniu.jiiiiiin.cn/OIa8pq.png)


### tr 处理文本内容

![](http://qiniu.jiiiiiin.cn/aAGeCs.png)

### sed 检索替换

![Text](http://qiniu.jiiiiiin.cn/ZFYuvJ.png)












## 命令相关

### witch

查询命令在哪个目录；


## 目录相关

```bash
# 回到上一个目录
cd -
```

