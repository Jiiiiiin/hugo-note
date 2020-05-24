---
title: "Shell Script 基础学习"
date: 2020-02-15T22:53:13+08:00
tags: ["linux", "shell-script"]
categories: ["shell-script"]

---

Shell Script 基础相关记录
<!--more-->


<!-- vim-markdown-toc GFM -->

* [Shell Type](#shell-type)
    * [是否是 Login Shell 类型之分](#是否是-login-shell-类型之分)
    * [是否是互动 Shell 之分](#是否是互动-shell-之分)
* [Shell Invocation](#shell-invocation)
* [Shell中可以执行的命令类型](#shell中可以执行的命令类型)
* [Shell 如何找到待执行的命令](#shell-如何找到待执行的命令)
* [指令查询方法](#指令查询方法)
* [变量设置 Variable Setting](#变量设置-variable-setting)
    * [全局变量](#全局变量)
    * [局部变量](#局部变量)
    * [declare 定义变量](#declare-定义变量)
* [变量替换 Variable Substitution](#变量替换-variable-substitution)
    * [查看一个变量内容 View a variable value](#查看一个变量内容-view-a-variable-value)
    * [变量值的扩充 Value Expansion](#变量值的扩充-value-expansion)
* [命令的输出 The export command](#命令的输出-the-export-command)
    * [查看环境变量 Viewing Environment Variable](#查看环境变量-viewing-environment-variable)
    * [变量撤销 Variable Revocation](#变量撤销-variable-revocation)
    * [使用 read 指令定义变量 Using read](#使用-read-指令定义变量-using-read)
* [别名 Command Alias](#别名-command-alias)
* [进程的继承关系 Process Hierarch](#进程的继承关系-process-hierarch)
    * [进程返回值](#进程返回值)
* [Shell Script定义](#shell-script定义)
    * [脚本运行方式](#脚本运行方式)
    * [Source 命令来跑shell脚本 Source Runing](#source-命令来跑shell脚本-source-runing)
    * [Exec命令来跑 shell 脚本 Exec Running](#exec命令来跑-shell-脚本-exec-running)
    * [选择如何执行你的shell脚本](#选择如何执行你的shell脚本)
    * [示例](#示例)
    * [排列成一行执行多行命令 Sequence Running](#排列成一行执行多行命令-sequence-running)
* [命令行群组 Command Grouping](#命令行群组-command-grouping)
* [具名的群组 Named Command Group](#具名的群组-named-command-group)
* [命令替换 Command Substitution](#命令替换-command-substitution)
    * [其他变量替换 Other Variable Substitution](#其他变量替换-other-variable-substitution)
        * [获取变量长度](#获取变量长度)
        * [获取子串在字符串中的索引位置](#获取子串在字符串中的索引位置)
        * [去头去尾](#去头去尾)
        * [截取子串](#截取子串)
        * [获取指定长度的变量值](#获取指定长度的变量值)
        * [变量值输出内容替换](#变量值输出内容替换)
* [数组 Array Setting](#数组-array-setting)
* [计算 Arithmetic Expansion](#计算-arithmetic-expansion)
    * [bc指令](#bc指令)
    * [expr 指令](#expr-指令)
    * [运算符 Arithmetic Operation](#运算符-arithmetic-operation)
* [脚本参数 Script Parameter](#脚本参数-script-parameter)
    * [参数取值 Gathering Parameters](#参数取值-gathering-parameters)
* [参数替换 Parameter Substitution](#参数替换-parameter-substitution)
* [参数变化 Parameter Shifting](#参数变化-parameter-shifting)
* [重置参数 Set Command](#重置参数-set-command)
* [脚本中的返回值 Return Value (RV)](#脚本中的返回值-return-value-rv)
* [条件返回 Conditional Running](#条件返回-conditional-running)
* [Test Condition](#test-condition)
    * [Test Expression](#test-expression)
    * [String Expression](#string-expression)
        * [例子 Test Example](#例子-test-example)
    * [Integer Expression](#integer-expression)
    * [File expression](#file-expression)
* [条件分之判断 The if-then Statement](#条件分之判断-the-if-then-statement)
    * [Using Command Group](#using-command-group)
    * [多轮条件判断 Multiple Conditions (elif)](#多轮条件判断-multiple-conditions-elif)
* [Case判断语法 Run By case](#case判断语法-run-by-case)
* [循环语句 Loop Statement](#循环语句-loop-statement)
    * [The for Loop](#the-for-loop)
    * [The while Loop](#the-while-loop)
    * [break](#break)
        * [Using cont inue In Loop](#using-cont-inue-in-loop)
* [函数 Function](#函数-function)
* [调试脚本](#调试脚本)
* [示例脚本](#示例脚本)

<!-- vim-markdown-toc -->

## Shell Type


+ Login Shell
    - Local login via console
    - Terminal program 
    - Remote login

+ Interactive Shell 
    - With shell prompt
    - Typing commands manually

### 是否是 Login Shell 类型之分

+ Login Shell 就是登录主机产生出来的 shell
+ 其他的就是非 Login Shell

### 是否是互动 Shell 之分

+ 存在 shell prompt 的或者不是
+ 一般 shell script 都是非互动类型

## Shell Invocation

shell 在启动的时候会执行一些预配置文件，根据 shell 的类型不同读取的设定内容也不同；

Login Shell

- /etc/profile

- then one of following in order

    + -/bash profile
    + -/bash login
    + -/profile

Interactive Shell

+ /etc/bash.bashrc

+ -/ bashrc

+ login shell type

etc 下面的这个配置必跑，下面的3个文件按照查找的优先级由上到下只会跑一个；

不同的发现版，这3个配置文件会稍有不同，Redhead 就是前两个；

其次，etc 下面的那个配置，是全局的，家目录中的某一个配置只是针对用户自己的；

用户的设定会覆盖全局的设定；


+ 互动式的 shell

会在执行后面两个预设文档；


## Shell中可以执行的命令类型
![Text](http://qiniu.jiiiiiin.cn/pSk3kv.png)

+ 可以使用 `compgen -[abcA] [function]`查询不同的可以执行的“命令”类型
![Text](http://qiniu.jiiiiiin.cn/AYGjiZ.png)
> [Basic of Linux shell Command](https://www.youtube.com/watch?v=iMjkC8fO3VU&list=PLSebY0Ugo-zdU_gqnSPj5rjrGUhIKh3aP)

## Shell 如何找到待执行的命令

![Text](http://qiniu.jiiiiiin.cn/SKxmqD.png)
+ 在PATH定义的目录中找到第一个可执行程序就会被使用
+ `which cd`

## 指令查询方法

![Text](http://qiniu.jiiiiiin.cn/t7Wler.png)


## 变量设置 Variable Setting

* Setting a variable:

    name=value

* Setting rules:
    * No space
    * No number beginning
    * No $ in name
    * Case sensitive


如果没有 quoting 不能有任何 IFS；

value 部分可以使用$来进行变量的引用；

+ 常见错误

`A= B` shell 解析的时候会赋一个空值给 A，然后将 A 变量丢给 B 命令去跑；

### 全局变量

+ 不做特殊声明， Shell中变量都是全局变量
+ Tips ：大型脚本程序中函数中慎用全局变量
+ 在函数中声明的变量，如果函数被调用过，“ 之后 ”这个变量也会变成全局变量；

### 局部变量

+ 定义变量时，使用local关键字
+ 函数内和外若存在同名变量，则函数内部变量覆盖外部变量


### declare 定义变量

declare命令和typeset命令两者等价

declare、typeset命令 都是用来定义变量类型的

![Text](http://qiniu.jiiiiiin.cn/NYNwRT.png)

-f 可以显示系统中（系统默认就定义了一些）定义好的一些可用函数，包括函数体，而-F
就只显示函数名；

![Text](http://qiniu.jiiiiiin.cn/PSY2ee.png)

shell 默认是以字符串来处理变量类型，所以需要使用 declare
来将一个变量声明成具体的类型；


## 变量替换 Variable Substitution

定义一个变量是为了在 shell 中去引用；

+ Substitute then re-construct: 
```bash
$ A=ls
$ B=la
$ C=/tmp
$ $A -$B  $C
```

+ Result:
`$ ls -la /tmp`

shell 在进行解析的时候，会先将变量替换得到一个*原始的命令内容* 之后再去执行转换后的原始命令；


 而且这个替换过程是在按 Enter 之前就已经完成了；

###  查看一个变量内容 View a variable value

Using the echo command:

```bash
$ echo $A -$B $C
ls -la /tmp
```

*echo 会将其 args 对到 STDOUT 上面*;

这样我们就很方便的查看一个变量的内容；

### 变量值的扩充 Value Expansion

+ Using separator:

    $ A=B:C: D

    $ A=$A:E
+ Using {}:

    $ A=BCD

    $ A=${A}E
+ 有分隔符号

比如使用冒号作为分隔符，在进行扩充的时候只需要使用 $引用原有的变量内容，在使用冒号分割后面跟新的值；

如果需要向前扩充，可以将扩充内容放在引用之前；

+ 没有分隔符

就在变量引用的时候使用括号来界定引用；

不加括号就会导致找不到引用；

***建议在 shell 脚本中都是用加上大括号的方式来进行变量的引用***

## 命令的输出 The export command

```
. Purpose:
To set Environment Variable, inheritable in sub shells.
```

linux 中进程是一棵树状结构，类似目录；

shell 中跑出来的进程，其父进程都是 shell；

shell 中定义的变量对于自己可见，对它的子进程是不可见的；

而这种变量就成为本地变量；

当然还有一种叫做环境变量，这种变量就会被子进程所继承，使用 export 命令就可以将一个本地变量升级成为一个环境变量；

`export valiable_name` export 后面跟指定要输出到环境的变量名即可；

需要注意导出的环境变量只影响自己何其子进程；

另外如果在子进程修改了变量的值，不会影响父进程；

再就是如果中间进程修改了一个变量，那么其下的子进程拿到的就是其最近的父进程的变量值，而不是祖父的；

```bash
Setting Environment Variable Using export command:
$ A=B
$ export A
Or
$ export A=B
Using declare command: $ declare 一x A
$ A=B
```

可以升级一个本地变量也可以直接定义一个环境变量；

或者先使用 declare命令 `-i` 先说明一个环境变量，在后面在赋值；

![Text](http://qiniu.jiiiiiin.cn/R5fAu0.jpg)

上图就是 export 一个变量前后对于不同进程（子进程)的影响；


###  查看环境变量 Viewing Environment Variable

+ Using env command: $ env
+ Using export command: $ export

`env` 列出系统所有环境变量；
`export` 只列出使用当前命令导出的环境变量；

### 变量撤销 Variable Revocation

***可以使用 unset 来清除一个环境变量***

+ Using unset command:

```
$ A=B
$ B=C
$ unset $A
```

上面这个例子将会撤销变量 `B`

Different to null value:

```
$ A=
$ unset A
```

空变量和撤销一个变量是不同的概念；

###  使用 read 指令定义变量 Using read

+ Geting variable values from STDIN: `$ read var1 var2 var3` 

该命令可以从标注输入或者管道读取变量的值；

read 可以先声明需要读取那几个变量；

如果给定的值比定义的变量多的时候，根据 IFS 分割，每个一一对应，如果多出来的全部给最后一个变量；

如果不够那么未赋值的变量的初始值就是空值；

针对 quoting 只有反斜线才会生效；

```
[vagrant@localhost ~]$ read a b c
aaa\ bbb ccc
[vagrant@localhost ~]$ echo $c

[vagrant@localhost ~]$ echo $b
ccc
[vagrant@localhost ~]$ echo $a
aaa bbb
```


+ Terminating input by pressing Enter 

在终端中输入完成之后按完 Enter 键之后就完成了输入

+ Positional assignment

    + Extras are assigned to the last variable

+ Common options:

```bash
# 可以在键入值的终端给出一句提示语 
-p ' prompt' : gives prompts

# 默认读取变量值是不限制长度的，使用该参数可以限定只会读取对应数值的字符 
-n n : gets n of characters enough

# 静音模式，即让用户输入的值变成不可见或者说不回显的 
-s : silent mode
```

+ 使用场景，在需要 shell 脚本临时暂停的时候可以使用该命令：

![Text](http://qiniu.jiiiiiin.cn/7P6ZjJ.jpg)

或者说，在执行脚本的过程中，需要用户交互式的键入一些变量值的场景；

## 别名 Command Alias

Setting an alias:

`$ alias alias_name='commands line'`

最好使用 quoting 来说明变量值；

Run defined commands by entering alias name.

User aliases are defined in `~/.bashrc`

个人定义的别名建议定义在家目录的配置文件；

Listing aliases:

`$ alias`

Removing an alias:

`$ unalias alias name`

alias 也是区分进程范围的，即子进程取消别名，不会影响父进程，比如 bash；

***临时取消 alias，在指令前面打反斜线即可*** `\ls`

+ 场景

 可以使用 ***alias***用来设计常指令；


## 进程的继承关系 Process Hierarch

+ Every command generates a process when running
+ A command process is a child while the shell is the parent
+ A child process returns a value ( ? ) to parent when exists .

每个进程在结束的时候都会送一个返回值给父进程；
在 shell 中使用`$?`即可查询最后一个进程结束返回的值；

### 进程返回值

在整个***Return Value***中只有两种状态，真和假；

真值为0；
假值为1~255；

在 shell 中能拿到的返回值就256个，只有0为真；

## Shell Script定义

Definition:

A series of command lines are predefined in a

text file for running.

脚本即按照写好的命令逐行执行；

### 脚本运行方式

![Text](http://qiniu.jiiiiiin.cn/ORKZ7M.png)

运行脚本的第一种方式就是，给脚本赋予执行权限，之后在shell中指定脚本路径就可以执行（跑）这个脚本；

另外一种就是给定一个先决条件，指定bash，然后将路径作为对于bash的指定参数即可；

+ Using a sub shell to run commands: Environment changing only effects the sub shell

shell中执行一个脚本，很重要的一个概念就是，shell会作为父进程，创建一个***sub-shell***进程来跑脚本；

每一条命令的返回值是返回到sub-shell，最后的返回值（命令和子进程）一般都是最后一条命令的返回值；

sub-shell也可以定义自己的返回值，在脚本中；

定义方式`exit return_value`，即使用exit命令加上返回值；

+ Interpreter is defined at the first line: `#!/path/to/shell`

shell脚本的第一行最佳实践都是需要声明脚本所编写的语境，即告诉shell怎么来翻译和执行这个脚本；

`#!`加上绝对路径来限定使用那个解析器；

可以是任何类型的shell或者其他脚本语言的程序；

如果在shell脚本第一行没有声明解析器，那么就以当前跑脚本的shell的类型作为sub-shell；

所以为了避免脚本被错误的shell类型解析，最佳实践就是在第一行制定翻译官；

> [Linux脚本开头#!/bin/bash和#!/bin/sh是什么意思以及区别](https://www.cnblogs.com/EasonJim/p/6850319.html)
> 应该说，/bin/sh与/bin/bash虽然大体上没什么区别，但仍存在不同的标准。标记为#!/bin/sh的脚本不应使用任何POSIX没有规定的特性 (如let等命令, 但#!/bin/bash可以)。Debian曾经采用/bin/bash更改/bin/dash，目的使用更少的磁盘空间、提供较少的功能、获取更快的速度。但是后来经过shell脚本测试存在运行问题。因为原先在bash shell下可以运行的shell script (shell 脚本)，在/bin/sh下还是会出现一些意想不到的问题，不是100%的兼用。

### Source 命令来跑shell脚本 Source Runing


![Text](http://qiniu.jiiiiiin.cn/iaSzfE.png)

Using source command to run script:

+ There is no sub shell, interpreter is ignored.

    这里就需要注意，因为没有sub-shell，所以如果脚本不是确切的shell类型，那么脚本在转译执行的时候肯定会出错；

    ***就算脚本第一行定义了翻译官程序，使用source执行的方式也不会看这行定义***，就因为没有sub-shell导致的；

    ***执行source指令还可以使用 . 替代source***

+ Environment changing effects the current shell.

    脚本如果修改了环境变量，将会影响到外部的shell本身；

+ 常用于：

    在linux中source是很常用的，比如我们定义一组环境变量，使用source之后，这些变量就在当前的shell中生效了；

    可以理解为***模块设计***的概念；

    类似一些语言中的import；



### Exec命令来跑 shell 脚本 Exec Running

![Text](http://qiniu.jiiiiiin.cn/EDX8ZQ.png)



Using exec command to run script:

+ The current shell is terminated at script starting.
+ The process is hanged over to interpreter.

    结束当前的shell进程然后跑脚本；

    当脚本跑完整个程序就结束了；


### 选择如何执行你的shell脚本

+ 如果你希望跑完脚本要把脚本定义的环境（变量）继承过来就使用source来跑；
+ 如果你希望跑完脚本不会影响环境（变量）那就使用正常的方式；
+ 如果你希望跑完脚本（一般都会在结束时候移交到下一个shell进程）就结束当前shell就使用exec来执行；

### 示例

Write a simple shell script (my. Sh)

```sh
pwd
cd /tmp
pwd
sleep 3
```

Make it executable 

`$ chmod +x my sh`

![Text](http://qiniu.jiiiiiin.cn/gB0Dz9.png)

上图使用了3中不同的方式来跑这个示例；

1. 使用正常方式，跑完之后执行pwd，发现当前shell环境没有被改变；

2. 使用source方式，执行之后发现当前路径被修改了；

3. `cd -` 先回到source之前的工作目录，使用exec的方式执行，执行完脚本之后，当前的shell进程将会终止；


### 排列成一行执行多行命令 Sequence Running

```bash
Using the: symbol S cmdl; cmd2; cmd3

Equivalent to

sss cmd1

cmd2

cmd 3
```


可以使用分号来分割不同的命令，这样就可以按序/在一行执行完多个命令；

## 命令行群组 Command Grouping

Using {} to run command group in current shell:

`{cmd1; cmd2; cmd3;}`

大括号执行不会产生sub-shell；


Using  () to run command group in a nested sub shell:

`(cmdl cmd2; cmd3)`

圆括号会产生sub-shell；

这里的sub-shell就是上面source执行和正常执行的差别；

+ Command Grouping Behavior

Using {}: 

Environment changing effects the current shell

Using  ():

Environment changing does NOT effects the current shell


## 具名的群组 Named Command Group

Also known as function

A command group is run when calling the function name

```sh
[vagrant@localhost ~]$ my_func () {
> cmd1;
> }
[vagrant@localhost ~]$ my_func
```

如果但看大括号中的内容，就可以类比为上面的***大括号命令群组***;

这种写法就是给大括号命令群组一个命名；

执行的时候，只需要打名字就可以了；

***这种写法在shell script中就叫做funcation***

## 命令替换 Command Substitution

![Text](http://qiniu.jiiiiiin.cn/LlEM0y.png)

是将命令的执行结果抓出来，在重新组建新的命令；

和变量的替换不一样；

Using $ ():

`$ cmd1 … $(cmd2 …) …`

上面的执行流程是：

1. 先执行cmd2，结果会塞回到cmd1
2. 再执行cmd1

下面反引号这种是传统方式，不建议使用，在嵌套替换的时候很麻烦；

Usin``  (don’t be confused with ‘’):

$ cmd1 … \`cmd2 …` …

上面这种做法是传统的方式，使用反引号

更准确的说应该是把命令的SDTOUT拿出来，SDTERR并不会导出来；

除非进行输出重定向；

如果是多层次的嵌套命令替换，那么会按出现的优先级来，但是最里面的肯定先会被替换；

+ 示例 1 使用日期指令进行推算

```sh
❯ cat 2.7-命令替换\(下\)/example_2.sh
#!/bin/bash
#

echo "This year have passed $(date +%j) days"
echo "This year have passed $(($(date +%j)/7)) weeks"

echo "There is $((365 - $(date +%j))) days before new year"
echo "There is $(((365 - $(date +%j))/7)) weeks before new year"
```

+ 示例 2 编写一个简单的 nginx 服务守护脚本

```bash
❯ cat 2.7-命令替换\(下\)/example_3.sh
#!/bin/bash
#

nginx_process_num=$(ps -ef | grep nginx | grep -v grep | wc -l)

if [ $nginx_process_num -eq 0 ];then
	systemctl start nginx
fi
```


### 其他变量替换 Other Variable Substitution

#### 获取变量长度


```bash
[vagrant@localhost ~]$ echo $a
haha
[vagrant@localhost ~]$ echo ${a}
haha
[vagrant@localhost ~]$ echo ${a}
[vagrant@localhost ~]$ echo ${#a}
4
```

使用 `${#valiable_name}` 获取对于变量的长度；

![Text](http://qiniu.jiiiiiin.cn/aqW274.png)

![Text](http://qiniu.jiiiiiin.cn/Wc9FPS.png)
#### 获取子串在字符串中的索引位置

`expr index $string $substring`


#### 去头去尾

![](http://qiniu.jiiiiiin.cn/STME1k.png)

${var#pattern}

removes shortest pattern at beginning

${var##pattern}

removes longest pattern at beginning

${var%pattern)

removes shortest pattern at end

${var%%pattern}

removes longest pattern at end

变量替换使用的是$，那么其在键盘左边的就是去除满足patten的左边的值，即利用#;
而%则代表右边；

```bash
[vagrant@localhost ~]$ y=abc
[vagrant@localhost ~]$ echo ${y#ab}
c
[vagrant@localhost ~]$ echo ${y%bc}
a
[vagrant@localhost ~]$ echo ${y}
abc
```

![Text](http://qiniu.jiiiiiin.cn/PI7I3Z.png)
![Text](http://qiniu.jiiiiiin.cn/xKM4Gx.png)
![Text](http://qiniu.jiiiiiin.cn/9IqoxC.png)

+ 示例：

截取出路径中的文件名：

![Text](http://qiniu.jiiiiiin.cn/4OeTZk.png)

```bash
# 自留下文件名
echo ${my_path##*/}

# 将绝对路径修改为相对
echo ${my_path#/}
```

这里的patten是路径匹配，参考shell路径匹配；

#### 截取子串

![Text](http://qiniu.jiiiiiin.cn/8W6nF1.png)


#### 获取指定长度的变量值

${var: n: m}

To have m characters from position n （position starting from 0）

获取从n开始的m个字符；

#### 变量值输出内容替换

${var/pattern/str} : substitutes the first pattern to str

${var//pattern/str}: substitutes all pattern to str

![Text](http://qiniu.jiiiiiin.cn/dtWG3A.png)

```bash
[vagrant@localhost ~]$ echo ${y//a/A}
Abc
[vagrant@localhost ~]$ echo ${y}
abc
```

## 数组 Array Setting 

Using  ():

`array=(valuel value2 value3)`

Position assignment:

```bash
array [0] =value1
array [1] =value2 
array [2] =value3
```


数组有多个值，变量只有一个值；

+ 取值

```bash
[vagrant@localhost ~]$ b=(a b c)
# @/* 都可以用来取出所有值
[vagrant@localhost ~]$ echo ${b[@]}
a b c
[vagrant@localhost ~]$ echo ${b[*]}
a b c
[vagrant@localhost ~]$ echo ${b[0]}
a
# 修改某个index对应的值
[vagrant@localhost ~]$ b[0]=haha
[vagrant@localhost ~]$ echo ${b[0]}
haha
# 取长度
# 取单个index对应值的长度
[vagrant@localhost ~]$ echo ${#b[0]}
4
# 取整个数组有多少个值
[vagrant@localhost ~]$ echo ${#b[@]}
3
```

## 计算 Arithmetic Expansion

+ 32bit integer:

    -2,147,483,648 to 2,147,483,647

+ No floating point !

    Using external commands instead :

    + bc
    + awk
    + perl

shell 目前只能处理整数；

### bc指令

bc是bash内建的运算器，支持浮点数运算

内建变量scale可以设置，默认为0，使用该参数可以将输出结果的小数点位数指定为对应位数，如：`echo
"scale=2;3/8" | bc`;

![Text](http://qiniu.jiiiiiin.cn/K9BjuC.png)
![Text](http://qiniu.jiiiiiin.cn/3CV0sf.png)

而小数的处理就只能依赖其他指令，如 bc；

```bash
[vagrant@localhost ~]$ a=$(echo '3.14*2' | bc)
[vagrant@localhost ~]$ echo $a
6.28

# 设定小数精度，scale=2标示保存两位小数
echo "scale=2;3/8" | bc
0.37
```

### expr 指令

![Text](http://qiniu.jiiiiiin.cn/G19HoJ.png)

![Text](http://qiniu.jiiiiiin.cn/0LRZHW.png)

![Text](http://qiniu.jiiiiiin.cn/S6f9yg.png)

注意：

+ 操作符号左右必须要加空格；
+ 在进行比较的时候，如果为真返回 1，这里和 shell 中执行命令如果执行成功返回 0
  是反着的；


技巧：

+ 判断一个数字是否是一个整数：

![Text](http://qiniu.jiiiiiin.cn/XsfYkq.png)

 可以看到如果一个数字不是一个整数在进行 expr 相加的时候就会返回一个非 0 结果；




### 运算符 Arithmetic Operation

Operators

```bash
+ add

- subtract

* multiply 

/ divide 

& AND 

| OR

^ XOR

! NOT
```

直接在shell中计算：

Using $ (()) or $ []:

```bash
$ a=5; b=7; c=2

$ echo $ ((a+b*c))

19

$ echo $ [(a+b) /c]

6
```

需要注意因为shell不处理小数，由此如果除法得到一个小数，那么其实也仅仅现实整数，或者说除出来的一定是只能得到整数；

另外一种就是使用declare声明一个变量类型为整数：

Using declare with variable:

```bash
$ declare -i d
$ d= (a+b) /c
$ echo $d

6
```

如果在赋值给一个变量之前没有执行 `declare -i`那么整个变量得到的只会是一个算术表达式字符串；

也可以使用let直接定义一个变量：

Using let with variable

```bash
$ let f= (a+b) /c
$ echo $f
```

+ 递增递减

Using  (()) with variable

在for循环类的代码程序里面递增递减会被常用；

```bash
$a=1
$((a++))
$echo $a

2

$((a-=5))
$echo $a

-3
```

## 脚本参数 Script Parameter 

+ Assigned in command line

    script_name par1 par2 par3 …

    直接跟在执行脚本命令的后面；

+ Reset by set command

    set par1 par2 par3 …

    重设参数，在执行的脚本中使用 `set`；

+ Separated by  <IFS>

    set "par1par2”\ par3 …

    设置参数是受控于 IFS的；

    上面的示例等于只设置了一个参数；

### 参数取值 Gathering Parameters
+ Substituted by $n (n=position) : $0 $1 $2 $3 …

+ Positions:

    - $0 : script_ name itself 

        $0 在脚本中永远只会抓到script的名字，在function中也是如此；
                    
        但是在function中使用$n就是去函数自己的参数；
    - $1 : the 1st parameter 
    - $2 : the 2nd parameter and SO on..

## 参数替换 Parameter Substitution
+ Reserved variables:
    
    parameter内建替换变数

    - $(nn] : position greater than 9
    - $# : the number of parameters
     
        除了$0之外一共有多少个参数；
        
        比如如果需要判断用户有没有传递参数到脚本就可以判断$#当前这个变量的长度，或者判断$1是否为空；

        ```sh
          #! /bin/bash
          [ "$1" ] || {
              echo "$0 : Error: miss params";
              exit 1;
          }
        ```
        
    - $@ or $*  : All parameters individually
    - “$*” : All parameters in one
    - “$@“ : All parameters with position reserved

        现实所有参数并维持原状；

+ 示例

定义一个param.sh

```sh
#! /bin/bash
echo fieename: $0
echo $1
echo $2
echo $3


echo '$#: ' $#
echo '$*: ' $*
echo '"$*": ' "$*"
echo '"$@": ' "$@"
```

执行：

```bash
[vagrant@localhost ~]$ ./param.sh 'a b' c
./param.sh
a b
c

$#:  2
# 因为没有双引号所以就算传参的时候使用了quoting，但是三个字符 abc还是会被打散，虽然肉眼看不出来；
$*:  a b c
# 而下面这种情况，abc是合并成一个参数或者说字段回显的
"$*":  a b c
# 这里就维持传参的quoting状态
"$@":  a b c
```

## 参数变化 Parameter Shifting

删除前n个脚本参数；

+ Using shift [n]
+ to erase the first n parameters,

假设我们的脚本文件（test.sh）如下：

```sh
#!/usr/bin/env bash
# 显示前三个位置参数。
echo "$1 $2 $3"
# 移除前两个位置参数，并将$3重命名为$1，之后的以此类推。
shift 2
echo "$1 $2 $3"
```

在终端执行该脚本：

sh test.sh q w e r t

返回信息如下：

```bash
q w e
e r t
```

## 重置参数 Set Command

可以使用set指令在脚本中重置参数；

![Text](http://qiniu.jiiiiiin.cn/yJfOf8.jpg)

## 脚本中的返回值 Return Value (RV)

+ Every command has a Return Value when exists, also called Exist Status.

+ Specified by exit in script:

    `exit [n]`

    Or, inherited from the last command

    在调用端可以拿到整个返回值做一些条件判断；

+ Using $? to have RV of last command

    使用`$?`获取返回值；

+ 返回值的取值范围和进程的返回值一样；

## 条件返回 Conditional Running
+ Using && to run only while TRUE:
    `cmd1 && cmd2`

  1. 命令之间使用 && 连接，实现逻辑与的功能。
  2. 只有在 && 左边的命令返回真（命令返回值 $? == 0），&& 右边的命令才会被执行。
  3. 只要有一个命令返回假（命令返回值 $? == 1），后面的命令就不会被执行。
+ Using ll to run only while FALSE:
   `cmd1 || cmd2` 

    1. 命令之间使用 || 连接，实现逻辑或的功能。
    2. 只有在 || 左边的命令返回假（命令返回值 $? == 1），|| 右边的命令才会被执行。这和 c 语言中的逻辑或语法功能相同，即实现短路逻辑或操作。
    3. 只要有一个命令返回真（命令返回值 $? == 0），后面的命令就不会被执行。
***在.linux中的任何指令都有返回值***

## Test Condition

Using test command to return TRUE or FALSE accordingly:
+ test expression
+ [ expression ]


使用test指令或者表达式字面量来进行条件判断，返回真假值；

以上两种写法都可以；
注意使用中括号的时候，括号两边都必须要都空格；

### Test Expression

+ ( EXPRESSION )

    EXPRESSION is true
    使用括号来确定优先级；

+ ! EXPRESSION

    EXPRESSION is false

+ EXPRESSION1 -a EXPRESSION2

    both EXPRESSION1 and EXPRESSION2 are true

    -a就是and的意思，只有两个表达式同时成立，才会为真；

+ EXPRESSION1 -o EXPRESSION2

    either EXPRESSION1 or EXPRESSION2 is true

    只要有一个表达式为真就就返回真；


+ 示例

判断给定文件用户拥有那组权限：

![Text](http://qiniu.jiiiiiin.cn/QrYoJK.png)

![Text](http://qiniu.jiiiiiin.cn/2Ob7EH.png)

递归的判断给定参数是否是文件：

![Text](http://qiniu.jiiiiiin.cn/XV8Snl.png)


表达式的内容只能有一下3中类型：String Expression/Integer Expression

### String Expression

+ -n STRING

    the length of STRING is nonzero

+ STRING equivalent to -n STRING

    上面两种是一样的意思；

    意思是字串的长度为非零的时候为真；

    非空字串为真，空字串为假值；

#### 例子 Test Example
Think about

```bash
$ unset A
$ test -n $A
$ echo $?
0

# 0 就是真，因为在翻译之后真正执行的test指令是 `test -n` 后面不接任何参数，那么-n在这里就不是选项而是args；因为 -n 是两个字串所以结果为真；

$ test -n "$A"
# 双引号内的解析得到一个预留的空字符串；
$ echo $?
1
```


+ -z STRING

    the length of STRING is zero

    当碰到空串为真；


+ STRING1 = STRING2

    the strings are equal

    字串相同为真；

    ```bash
    [vagrant@localhost ~]$ A="a"
    [vagrant@localhost ~]$ B="c"
    [vagrant@localhost ~]$ [ "$A" = "$B" ]
    [vagrant@localhost ~]$ echo $?
    1
    [vagrant@localhost ~]$ B="a"
    [vagrant@localhost ~]$ [ "$A" = "$B" ]
    [vagrant@localhost ~]$ echo $?
    0
    ```

    最好在进行比较的时候将变量进行quoting；
    

+ STRING1 != STRING2

    the strings are not equal

    字串不相同为真；

### Integer Expression

只能对比整数，需要对比小数需要使用类似bc这样的程序；

+ INTEGER1 -eq INTEGER2

    INTEGER1 is equal to INTEGER2

+ INTERGER1 -ge INTEGER2

    INTERGER1 is greater than or equal to INTEGER2

+ INTERGER1 -gt INTEGER2

    INTEGERl is greater than INTEGER2

+ INTERGER1 -le INTEGER2

    INTEGERl is less than or equal to INTEGER2

+ INTEGER1 -lt INTEGER2

    INTEGER1 is less than INTEGER2

+ INTEGER1 -ne INTEGER2

    INTEGER1 is not equal to INTEGER2

### File expression

_+ FILE1 -nt FIle2

    FILE1 is newer (mtime)than FILE2

    左边的文档是否比右边要新；

_+ FILE1 -ot FIlE2

    FILE1 is older than FIle2

> [更多选项](https://www.slideshare.net/kennychennetman/linux-fundamental-chap-14-shell-script)


## 条件分之判断 The if-then Statement
Syntax:
	
```sh
if cmd1
then
    cmd2 …
fi
```

```sh
if [ хххх ]; then
    cmd2
fi
```

```sh
if cmd1
then
    cmd2 ...
else
    cmd3 ...
fi
```

else语句必须要声明then；
    

```sh
if cmd1
then
    # : 标示空命令永远返回真
    :
else
    cmd3 ...
fi
```

### Using Command Group
Syntax:

```sh
cmd1 && {
    cmd2 …
    # 注意这里必须做一个返回真的写法，避免群组中的命令执行返回假，cmd3被执行，就不是if else 条件语句的预期
    :
}  ||  {
    cmd3 …
}
```

### 多轮条件判断 Multiple Conditions (elif)

> ![Text](http://qiniu.jiiiiiin.cn/8ASYYZ.png)

如果第一个if条件没有执行，就会判断第二轮 elif的条件判断语句，如果第一个if块被执行（条件为真），那么就不走第二轮；

类似swich语句；


## Case判断语法 Run By case
Syntax: 

![Text](http://qiniu.jiiiiiin.cn/iAQXX6.png)

可以用于比较的包括整数/字符串/文档；

![Text](http://qiniu.jiiiiiin.cn/Vfry6E.png)

使用*号来兜底，在上面的case都不满足的情况下执行；

![Text](http://qiniu.jiiiiiin.cn/hUTfXP.png)

![Text](http://qiniu.jiiiiiin.cn/JhFFx5.png)

可以使用｜线来添加单个case的符合条件值；

+ 示例

定义一个让用户输入 yes 确认的方法：

![Text](http://qiniu.jiiiiiin.cn/rs76SB.png)

## 循环语句 Loop Statement
Loop flow:

![Text](http://qiniu.jiiiiiin.cn/vSbMaL.png)


### The for Loop
Syntax:

```bash
for VAR in values …
do 
	commands 
done
```

for 后面可以定义一个变量；

in后面就是这个变量的值；

do ... done 中间就是循环的内容；

值的个数决定循环的次数；

在循环里面可以使用 `$VAR` 获取循环中迭代的值；

![Text](http://qiniu.jiiiiiin.cn/36X62Z.png)

Tips:
+ A new variable is set when running a for loop
+ The value sources are vary.
+ The times of loop depends on the number of value.
+ Each value is used once in the do一 done statement in order.
### The while Loop
Syntax:

```sh
while cmd1 
do
	cmd2 …
done
```

while 后面为真，do done中的内容就会循环执行；

Tips:
+ The cmd1 is run at each loop cycle.
+ The do一done statement only be run while cmd1 returns TRUE value.
+ The whole loop is terminated once cmd1 returns FALSE value.
+ Infinity loop may be designed in purpose, or accidentally,

![Text](http://qiniu.jiiiiiin.cn/EL4juw.png)


### break

![Text](http://qiniu.jiiiiiin.cn/8ovZNy.png)

Tips:
+ The loop is terminated once the break runs
+ A number can be specified to break the Nth outbound loop.

![Text](http://qiniu.jiiiiiin.cn/spXCRh.png)

break 可以选择跳脱出那层循环，默认是`break 1`,上面的图中可以使用`break 3`跳出最外层循环；

![Text](http://qiniu.jiiiiiin.cn/GtwT9O.png)

也支持 continue，切 `continue n`即为跳出第几层的当次循环；

#### Using cont inue In Loop
Tips:

+ The remained lines in current loop cycle are omitted once the continue runs, script goes straight to continue next cycle.
+ A number can be specified to continue the Nth outbound loop.

![Text](http://qiniu.jiiiiiin.cn/f5AFwu.png)


## 函数 Function

+ Linux Shell中的函数和大多数编程语言中的函数一样

+ 将相似的任务或代码封装到函数中，供其他地方调用.

语法：

![Text](http://qiniu.jiiiiiin.cn/mN2wTT.png)

![Text](http://qiniu.jiiiiiin.cn/6ZcPAr.png)

+ 直接使用函数名调用，可以将其想象成Shell中的一条命令
+ 函数内部可以直接使用参数$1、$2... $n
+ 调用函数： function name $1 $2

+ 参数传递

![Text](http://qiniu.jiiiiiin.cn/ZnDCnC.png)
![Text](http://qiniu.jiiiiiin.cn/WKyUxF.png)

+ 返回值

![Text](http://qiniu.jiiiiiin.cn/L5huYk.png)

+ 使用return返回值，只能返回1一255的整数
+ 函数使用return返回值，通常只是用来供其他地方调用获取状态，因此通常仅返回0或1 ； 0表示成功， 1表示失败
+ 默认 return 返回的是 0；
+ 使用echo返回值
    + 使用echo可以返回任何字符串结果
    + 通常用于返回数据，比如一个字符串值或者列表值

```bash
#!/bin/bash
#

function get_users
{
	users=`cat /etc/passwd | cut -d: -f1`
	echo $users
}

user_list=`get_users`

index=1
for u in $user_list
do
	echo "The $index user is : $u"
	index=$(($index+1))
done
```



## 调试脚本

![Text](http://qiniu.jiiiiiin.cn/ONnsUD.png)

```bash
 [vagrant@localhost ~]$ bash -x ./param.sh
+ '[' '' ']'
+ show_error
+ echo './param.sh : Error: miss params'
./param.sh : Error: miss params
+ show_usage
+ echo Usage:
Usage:
+ echo -e '\t./param.sh file'
	./param.sh file
+ sleep 5
+ exit 1
[vagrant@localhost ~]$ cat ./param.sh
#! /bin/bash
show_usage () {
    echo Usage:
    echo -e "\t$0 file"
    sleep 5
}
show_error () {
    echo "$0 : Error: miss params";
}
[ "$1" ] || {
    show_error
    show_usage
    exit 1;
}
```

+ -x 回显进程执行流程

sh 的选项：

```bash
-c string：命令从-c后的字符串读取。
-i：实现脚本交互。
-n：进行shell脚本的语法检查。
-x：实现shell脚本逐条语句的跟踪。
```

这里可以使用-x 来查看脚本的执行情况。

![Text](http://qiniu.jiiiiiin.cn/E1aDYW.png)
## 示例脚本

+ 将当前脚本执行的进程排查掉 grep 的判断语句

```sh
#!/bin/bash
#

# 获取当前脚本执行进程的 pid
this_pid=$$

while true
do
ps -ef | grep nginx | grep -v grep | grep -v $this_pid &> /dev/null

if [ $? -eq 0 ];then
	echo "Nginx is running well"
	sleep 3
else
	systemctl start nginx
	echo "Nginx is down,Start it...."
fi
done

```

上面 ps 执行的一句中 grep -v $$ 就可以排除掉当前脚本运行的进程的干扰，避免脚本名称和 grep 的条件产生冲突；


