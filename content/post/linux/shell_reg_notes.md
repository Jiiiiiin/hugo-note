---
title: "Shell_reg_notes"
date: 2020-02-23T23:29:00+08:00
draft: true
---
shell 中正则的使用记录；
<!--more-->


<!-- vim-markdown-toc GFM -->

* [正则相关](#正则相关)
* [Shell 通配符](#shell-通配符)
    * [?字符](#字符)
    * [* 字符](#-字符)

<!-- vim-markdown-toc -->

## 正则相关 

> [Shell正则表达式参考表](https://man.linuxde.net/docs/shell_regex.html)


## Shell 通配符

> [命令行通配符教程](http://www.ruanyifeng.com/blog/2018/09/bash-wildcards.html)

> 一次性操作多个文件时，命令行提供通配符（wildcards），用一种很短的文本模式（通常只有一个字符），简洁地代表一组路径。

> 通配符早于正则表达式出现，可以看作是原始的正则表达式。它的功能没有正则那么强大灵活，但是胜在简单和方便。

### ?字符
?字符代表 单个字符。

```bash
#存在文件a.txt和b.txt

$ls?.txt
a.txt b.txt
```

上面命令中，? 表示单个字符，所以会同时匹配a.txt和b.txt。

如果匹配多个字符，就需要多个? 连用。

```bash
#存在文件a.txt、b.txt和ab.txt

$ ls ??.txt
ab. txt
```

上面命令中，?? 匹配了两个字符。

***注意，? 不能匹配空字符。也就是説，它占据的位畳必須有字符存在。***

### * 字符
*代表任意数量的字符。

```bash
# 存在文件 a.txt、b.txt 和 ab.txt
$ ls *.txt
a.txt b.txt ab.txt

# 输出所有文件
$ ls *
```

上面代码中，*匹配任意长度的字符。

*可以匹配空字符。

```bash
# 存在文件 a.txt、b.txt 和 ab.txt
$ ls a*.txt
a.txt ab.txt
```



