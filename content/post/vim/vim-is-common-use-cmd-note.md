---
title: "Vim 基础学习"
date: 2020-02-16T11:29:13+08:00

tags: ["Vim"]
categories: ["Vim"]
draft: true
---

记录自己使用 `vim` 的一些总结。
<!--more-->

<!-- vim-markdown-toc Redcarpet -->

* [Tips](#tips)
    * [其他](#其他)
    * [可视块 Visual Block](#可视块-visual-block)
    * [文本对象 Text Object](#文本对象-text-object)
    * [大小写转换](#大小写转换)
    * [缩进](#缩进)
    * [临时退出 vim 回到 shell](#临时退出-vim-回到-shell)
    * [移动光标 Moving cursor](#移动光标-moving-cursor)
    * [交换相邻字符或行](#交换相邻字符或行)
    * [回退光标 The fallback cursor](#回退光标-the-fallback-cursor)
    * [检索文本 Search Txt](#检索文本-search-txt)
        * [Magic/ very magic](#magic-very-magic)
        * [查找](#查找)
        * [显示搜索命令历史](#显示搜索命令历史)
        * [搜索当前词](#搜索当前词)
        * [搜索大小写敏感](#搜索大小写敏感)
        * [最近一次查找](#最近一次查找)
        * [查找与替换](#查找与替换)
            * [作用范围](#作用范围)
        * [替换标志](#替换标志)
        * [查找替换 Find and repalce](#查找替换-find-and-repalce)
    * [查看历史 show history](#查看历史-show-history)
    * [拷贝 Copy](#拷贝-copy)
    * [折行相关](#折行相关)
    * [文本编辑 Edit txt](#文本编辑-edit-txt)
    * [补全 Complete](#补全-complete)
    * [格式化 Formate](#格式化-formate)
        * [撤消与重做](#撤消与重做)
    * [寄存器 Register](#寄存器-register)
    * [缓冲区（buffer）](#缓冲区（buffer）)
        * [缓冲区跳转](#缓冲区跳转)
    * [分屏 Split Screen](#分屏-split-screen)
* [执行外部命令 exec external cmd](#执行外部命令-exec-external-cmd)
* [插件](#插件)
    * [起始屏替换](#起始屏替换)
    * [自动保存编辑内容](#自动保存编辑内容)
    * [配色方案](#配色方案)
    * [输入法切换](#输入法切换)
    * [NERDTree](#nerdtree)
    * [ctrlpvim/ctrlp.vim](#ctrlpvim-ctrlp-vim)
    * [LeaderF](#leaderf)
    * [YouCompleteMe](#youcompleteme)
    * [snippets 代码片段相关](#snippets-代码片段相关)
    * [其他待整理插件 Other Plugins](#其他待整理插件-other-plugins)
    * [vim-autoformat](#vim-autoformat)
* [安装 vim](#安装-vim)
* [配置 Config](#配置-config)
    * [键盘映射](#键盘映射)
* [模式 mode](#模式-mode)
* [函数](#函数)
* [录制宏](#录制宏)

<!-- vim-markdown-toc -->

> [简明 VIM 练级攻略](https://coolshell.cn/articles/5426.html)

> [vim入门指南](http://wklken.me/posts/2013/08/04/translation-vim-introduction-and-tutorial.html)

> [那些鲜为人知的 Vim 小技巧](https://harttle.land/2015/12/03/little-known-vim-skills.html)

> [实用技巧](https://www.ibm.com/developerworks/cn/linux/l-tip-vim1/index.html)
## Tips

### 其他

    Ctrl-g 显示当前编辑文件名及行数；


### 可视块 Visual Block

可视块使得能够在选中文本每一行某个位置插入一个字符

假设你选中了一块代码(Ctrl-v),你可以键入I，在代码块之前插入文本(切换到插入模式).当你离开插入模式时，输入的文本将作用于选中的每一行.使用A在代码块之后进行插入

另一个有用的特性是，你可以用新文本替换整个代码块.选中代码块，输入s，vim进入插入模式，然后输入内容.离开插入模式时，vim将输入的内容插入到剩余行

### 文本对象 Text Object

Vim命令操作文本对象(字符，单词，括号分割的字符，句子等等)

inner-word/block和a-word/block的区别在于，前者只选中单词的字符(不包括空白字符) 或者括号中的内容(不包括括号本身).后者包括括号本身或者单词后的空白字符

```vim
iw 单词
aw 单词+后面空白
iW …inner WORD
aW …a WORD
is 句子
as 句子+后面空白
ip 段落
ap 段落+段落后空白
i( or i) 括号中
a( or a) 括号中+括号
i< or i>
a< or i>
i{ or i}
a{ or a}
i" 引号中
a" 引号中+引号
i`
a`
```



### 大小写转换

+ ~ 将光标下的字母大小写反向转换
+ guw 将光标所在的单词变为小写
+ guw 将光标所在的单词变为小写
+ gUw 将光标所在的单词变为大写
+ guu 光标所在的行所有字符变为小写
+ gUU 光标所在的行所有字符变为大写
+ `g~~ 光标所在的行所有字符大小写反向转换`


### 缩进


在编辑代码时一个很有用的命令是调整代码缩进，可以很方便地增加（或减少）若干级缩进，并自动根据选项设定使用正确的空格或制表符。只需要使用“V”选中你要调整的代码行，然后键入“<”（或“>”）即可增加（或减少）一级缩进；在键入“<”（或“>”）之前键入数字则可以指定增加（或减少）的缩进级数。

+ `>> 右缩进（可配合操作数使用）`
+ `<< 左缩进（可配合操作数使用）`

### 临时退出 vim 回到 shell

1. 使用 Ctrl-z 以及 fg 这两个命令组合

这一解决方法主要利用了 Linux/Unix 的作业机制。具体原理是：Ctrl-z 命令将当前的 Vi/Vim 进程放到后台执行，之后 shell 环境即可为你所用；fg 命令则将位于后台的 Vi/Vim 进程放到前台执行，这样我们就再次进入 Vi/Vim 操作界面并恢复到原先的编辑状态。

2. 使用行命令 :sh

在 Vi/Vim 的正常模式下输入 :sh即可进入 Linux/Unix shell 环境。在要返回到 Vi/Vim 编辑环境时，输入 exit 命令即可。

　　这两种方法实现机制不一定，但效果一样，都非常快捷有效。

### 移动光标 Moving cursor

Vi/Vim 中关于光标移动的命令非常多，这也是很多人经常困惑并且命令用不好的地方之一。其实 Vi/Vim 中很多命令是针对不同的操作单位而设的，不同的命令对应不同的操作单位。因而，在使用命令进行操作的时候，首先要搞清楚的就是要采用哪种操作单位，也就是说，是要操作一个字符，一个句子，一个段落，还是要操作一行，一屏、一页。单位不同，命令也就不同。只要单位选用得当，命令自然就恰当，操作也自然迅速高效；否则，只能是费时费力。这也可以说是最能体现 Vi/Vim 优越于其它编辑器的地方之一，也是 Vi/Vim 有人爱有人恨的地方之一。在操作单位确定之后，才是操作次数，即确定命令重复执行的次数。要正确高效的运用 Vi/Vim 的各种操作，一定要把握这一原则：先定单位再定量。操作对象的范围计算公式为：操作范围 = 操作次数 * 操作单位。比如：5h 命令左移 5 个字符，8w 命令右移 8 个单词。

Vi/Vim 中操作单位有很多，按从小到大的顺序为（括号内为相应的操作命令）：字符（h、l）→ 单词 (w、W、b、B、e) → 行 (j、k、0、^、$、:n) → 句子（(、)）→ 段落（{、}）→ 屏 (H、M、L) → 页（Ctrl-f、Ctrl-b、Ctrl-u、Ctrl-d) → 文件（G、gg、:0、:$）。

+ 在Vim中多数操作都支持数字前缀，比如10j可以向下移动10行。
+ 多数情况下单词移动比字符移动更加高效。 w移动光标到下一个单词的词首，b移动光标到上一个单词的词首；e移动光标到下一个单词的结尾，ge移动光标到上一个单词的结尾。
+ 相对屏幕移动

    通过c-f向下翻页，c-b向上翻页；c-e逐行下滚，c-y逐行上滚。这在几乎所有Unix软件中都是好使的，比如man和less。 H可以移动到屏幕的首行，L到屏幕尾行，M到屏幕中间。

    zt可以置顶当前行，通常用来查看完整的下文，比如函数、类的定义。 zz将当前行移到屏幕中部，zb移到底部。

```bash
# tips
0 当前行第一列
^ 当前行第一个非空白字符
w 移到下一个单词
W 移到下一个单词，忽略标点
e 移动到单词尾部
E 移动到单词尾部，忽略标点
b 移动到单词开头
B 移动到单词开头，忽略标点
ge 移动到前一个词尾部
gE 移动到前一个词尾部，忽略标点
g_ 移动到最后一个非空白字符
$  移动到最后一列
```

### 交换相邻字符或行

+ xp 交换光标位置的字符和它右边的字符
+ ddp 交换光标位置的行和它的下一行

### 回退光标 The fallback cursor

在光标跳转之后，可以通过c-o返回上一个光标位置，c-i跳到下一个光标位置。

### 检索文本 Search Txt
> [在 Vim 中优雅地查找和替换](https://harttle.land/2016/08/08/vim-search-in-file.html)

> [Vim的正则表达式](https://www.jianshu.com/p/3abd6fbc3322)

> [Vim搜索字符转义与very magic搜索模式-Vim使用技巧(14)](https://vimjc.com/vim-very-magic.html)
>
>
> 对于Vim的正则表达式引擎来说，方括号 [] 缺省具有特殊含义，不需要转义；圆括号 () 默认会按原义匹配字符，因此需要使用 \ 转义，使其具有特殊含义；花括号 {} 也一样需要使用 \ 转义，但与之对应的闭括号则不用，因为 Vim 会自动推测我们的意图。这就是Vim的 magic 搜索模式。
> 对于Vim的正则表达式搜索，一个通用的原则是：如果想按正则表达式查找，就用模式开关 \v，如果想按原义查找文本，就用原义开关 \V。

#### Magic/ very magic

magic就是设置哪些元字符要加反斜杠哪些不用加的。 简单来说：

+ magic (\m)：除了`$ . * ^ `之外其他元字符都要加反斜杠。
+ nomagic (\M)：除了`$ ^` 之外其他元字符都要加反斜杠。

这个设置也可以在正则表达式中通过 \m \M 开关临时切换。 \m 后面的正则表达式会按照 magic 处理，\M 后面的正则表达式按照 nomagic 处理， 而忽略实际的magic设置。

+ \v （即 very magic 之意）：任何元字符都不用加反斜杠
+ \V （即 very nomagic 之意）：任何元字符都必须加反斜杠

默认设置是 magic，vim也推荐大家都使用magic的设置，在有特殊需要时，直接通过\v\m\M\V 即可。

#### 查找

在normal模式下按下`/`即可进入查找模式，输入要查找的字符串并按下回车。
Vim会跳转到第一个匹配。按下`n`查找下一个，按下`N`查找上一个。

Vim查找支持正则表达式，例如`/vim$`匹配行尾的`"vim"`。
需要查找特殊字符需要转义，例如`/vim\$`匹配`"vim$"`。

> 注意查找回车应当用`\n`，而替换为回车应当用`\r`（相当于`<CR>`）。

#### 显示搜索命令历史

    可以选择重用以前用过的搜索查找命令

    q/ 显示搜索命令历史的窗口

    q? 显示搜索命令历史的窗口

#### 搜索当前词

按下*即可搜索当前光标所在的词（word），再次按下搜索下一个。 按下#搜索上一个。

这在查找函数名、变量名时非常有用。

按下g*即可查找光标所在单词的字符序列，每次出现前后字符无要求。 即foo bar和foobar中的foo均可被匹配到。



#### 搜索大小写敏感

默认Vim搜索命令是大小写敏感的，因此，搜索 the 不会查找到 The。使用命令 :set ignorecase 会使得Vim搜索变得不区分大小写。

不管 ignorecase 选项的值是什么，都可以在搜索命令中使用 \c 来强制使得当前搜索模式不区分大小写，而命令 \C 则会强制当前搜索模式大小写敏感。
因此，/the\c 既会查找 the，也会查找到 The。


#### 最近一次查找

进行过Vim搜索后，当 /、?、:s、:g
命令使用空的搜索模式时会沿用最近一次的搜索模式。所以，在搜索完某个单词后，使用Vim替换命令
:%s//new/g 会将之前搜索的单词全部替换为 new。


#### 查找与替换

:s（substitute）命令用来查找和替换字符串。语法如下：
```bash
:{作用范围}s/{目标}/{替换}/{替换标志}
```

例如:%s/foo/bar/g会在全局范围(%)查找foo并替换为bar，所有出现都会被替换（g）。

使用正则替换某些文本，输入 :%s/old/new/gc 这个命令将会遍历整个文件%, 用单词”new”替换所有”old”. g代表替换行中所有匹配文本，c代表替换前询问

##### 作用范围
作用范围分为当前行、全文、选区等等。

+ 当前行：

```bash
:s/foo/bar/g
```

+ 全文：

```bash
:%s/foo/bar/g
```

+ 选区，在Visual模式下选择区域后输入:，Vim即可自动补全为 :'<,'>。

```bash
:'<,'>s/foo/bar/g
```

+ 2-11行：

```bash
:5,12s/foo/bar/g
```

+ 当前行.与接下来两行+2：

```bash
:.,+2s/foo/bar/g
```

#### 替换标志
上文中命令结尾的g即是替换标志之一，表示全局global替换（即替换目标的所有出现）。 还有很多其他有用的替换标志：

空替换标志表示只替换从光标位置开始，目标的第一次出现：

```bash
:%s/foo/bar
```

i表示大小写不敏感查找，I表示大小写敏感：

```bash
:%s/foo/bar/i
# 等效于模式中的\c（不敏感）或\C（敏感）
:%s/foo\c/bar
```

c表示需要确认，例如全局查找"foo"替换为"bar"并且需要确认：

```bash
:%s/foo/bar/gc
```

回车后Vim会将光标移动到每一次"foo"出现的位置，并提示

```bash
replace with bar (y/n/a/q/l/^E/^Y)?
```

按下y表示替换，n表示不替换，a表示替换所有，q表示退出查找模式， l表示替换当前位置并退出。^E与^Y是光标移动快捷键，


#### 查找替换 Find and repalce

> [在 Vim 中优雅地查找和替换](https://harttle.land/2016/08/08/vim-search-in-file.html)

+ 命令模式粘贴
如果希望全局查找替换当前光标所在的单词，我们可能需要手动地在命令模式下敲出来：%s/foo/bar/g。 但如果当前光标就在那个单词上的话，可以在敲完%s/之后将它粘贴到命令里：

```
<Ctrl+R>
<Ctrl+W>
```

这是命令模式的<Ctrl+R>工具，用法还包括粘贴当前文件路径：<Ctrl+R>%。 更多用法请查看帮助：:help c_CTRL-R。

### 查看历史 show history

```vim
命令行模式下：
:history 查看所有命令行模式下输入的命令历史
:history search或 / 或？ 查看搜索历史

普通模式下：
q/ 查看使用/输入的搜索历史
q? 查看使用？输入的搜索历史
q: 查看命令行历史

```


### 拷贝 Copy

+ 拷贝一行：^y$。


### 折行相关 

> [vim-折叠](https://medium.com/@invisprints/vim-%E6%8A%98%E5%8F%A0-b050b7e664b8)



### 文本编辑 Edit txt

　　与光标移动一样，Vi/Vim 中关于编辑操作的命令也比较多，但操作单位要比移动光标少得多。按从小到大的顺序为（括号内为相应的操作命令）：字符 （x、c、s、r、i、a）→ 单词 (cw、cW、cb、cB、dw、dW、db、dB) → 行 (dd、d0、d$、I、A、o、O) → 句子（(、)）→ 段落（{、}）。这些操作单位有些可以加操作次数。操作对象的范围计算公式为：操作范围 = 操作次数 * 操作单位。比如：d3w 命令删除三个单词，10dd 命令删除十行。


> [技巧：快速提高 Vi/Vim 使用效率的原则与途径](https://www.ibm.com/developerworks/cn/linux/l-cn-tip-vim/index.html)

+ 指令代指

```bash
i: insert
a: append
o: open a line below

# tips

d 删除当前光标位置到下一个命令哪个提供位置之间的字符(例如: d$删除当前行光标位置到最后一列的所有字符)
c 修改
x 删除光标位置字符
X 删除光标之前的字符(相当于回退)
y 拷贝
p 在当前光标之后黏贴拷贝的内容
P 在当前光标之前黏贴拷贝的内容
r 替换当前字符
s 用输入替换当前位置到下一个命令给出位置的字符
. 重复上一个命令
```

### 补全 Complete

在你输入时，反复输入同一个词是很正常的事情. 使用Ctrl-p，vim会反向搜索最近输入过的拥有相同开头的词

如果你不确定如何拼写某个词，并且你设置了拼写检查(:set spell),你可以使用 Ctrl-x Ctrl-k 到字典中查询已经输入的词.Vim自动补全系统在7.0后得到了很大的改善.

注意，自动补全命令仅在插入模式下有效，在命令模式有其他的作用

### 格式化 Formate

+ 格式化功能gg=G


#### 撤消与重做

+ u 撤消更改

在 Vim 中，undo(撤销)是最常用的操作之一，可以通过按u实现。如果需要进行多次undo（例如需要退回到3次修改以前），可以按3 u。

也可以键入:u或者:undo来进行撤销。这样做的缺点是键入一次只能撤销一次，且不如u方便快捷。

另外U经常被不经意间按到，导致在想要撤销一次更改（u）的时候却发现整行的更改都被撤销了。日常使用中U真正的使用场景相对u来说少很多。

+ Ctrl-R 重做更改

当撤销了一次或者几次操作后，发现撤销得多了，就需要redo来恢复。

可以通过按CTRL-R来进行重做操作。

当然也可以通过键入:red或者:redo来进行重做。

### 寄存器 Register

> [Vim 寄存器完全手册](https://harttle.land/2016/07/25/vim-registers.html)

Vim自动保存最后几个复制或删除的内容,要查看寄存器的内容，输入:registers, 你可以使用它们去黏贴一些老的文本。

常见文本编辑器都会提供剪切板来支持复制粘贴，Vim 也不例外。
不同的是 Vim 提供了 10 类共 48 个寄存器，提供无与伦比的寄存功能。
最常用的 `y` 操作将会拷贝到默认的匿名寄存器中，我们也可以指定具体拷贝到哪个寄存器中。

一般来讲，可以用 `"{register}y` 来拷贝到 `{register}` 中，
用 `"{register}p` 来粘贴 `{register}` 中的内容。例如：
`"ayy` 可以拷贝当前行到寄存器 `a` 中，而 `"ap` 则可以粘贴寄存器 `a` 中的内容。

除了 `a-z` 26 个命名寄存器，Vim 还提供了很多特殊寄存器。合理地使用可以极大地提高效率。例如：

* `"+p` 可以粘贴剪切板的内容，
* `":p` 可以粘贴上一个 Vim 命令（比如你刚刚费力拼写的正则表达式），
* `"/p` 可以粘贴上一次搜索关键词（你猜的没错，正是 normal 模式下的 `/foo` 搜索命令）。

在 Vim 中可通过 `:reg` 来查看每个寄存器当前的值。


### 缓冲区（buffer）

> [Vim 多文件编辑：缓冲区](https://harttle.land/2015/11/17/vim-buffer.html)
> 
> 缓冲区是一个文件的内容占用的那部分Vim内存 A buffer is an area of Vim’s memory used to hold text read from a file. In addition, an empty buffer with no associated file can be created to allow the entry of text. –vim.wikia

![pic alt](https://harttle.land/assets/img/blog/tabs-windows-buffers.png "opt title")

一个窗口内只有一个Buffer是处于可见状态的;

```
# 将多个文件放入缓冲区
vim file1 file2 ...
```

进入Vim后，通过:e[dit]命令即可打开某个文件到缓冲区。还记得吗？使用:new可以打开一个新窗口。 关闭一个文件可以用:q，移出缓冲区用:bd[elete]（占用缓冲区的文件对你毫无影响，多数情况下不需要这样做）。

如果Buffer未保存:bd会失败，如果强制删除可以:bd!。


#### 缓冲区跳转

缓冲区之间跳转最常用的方式便是 Ctrl+^（不需要按下Shift）来切换当前缓冲区和上一个缓冲区。 另外，还提供了很多跳转命令：

```
:ls, :buffers       列出所有缓冲区
    % 当前window
    # 替换buffer (使用 :e# or :b#切换)
    a 活动的(加载并可见)
    h 隐藏的(加载但不可见)
    + 修改的
:bn[ext]            下一个缓冲区
:bp[revious]        上一个缓冲区
:b {number, expression}     跳转到指定缓冲区
:bd 关闭buffer并从buffer列表移除(不关闭vim,即使最后一个buffer关闭)
:bun 关闭buffer但留存在bufferlist
:sp #N 分屏并编辑buffer N
```

:b接受缓冲区编号，或者部分文件名。例如：
+ :b2将会跳转到编号为2的缓冲区，如果你正在用:ls列出缓冲区，这时只需要输入编号回车即可。
+ :b exa将会跳转到最匹配exa的文件名，比如example.html，模糊匹配打开文件正是Vim缓冲区的强大之处。

### 分屏 Split Screen

> [Vim 多文件编辑：窗口](https://harttle.land/2015/11/14/vim-window.html)

标签页(tab)、窗口(window)、缓冲区(buffer)是Vim多文件编辑的三种方式，它们可以单独使用，也可以同时使用。 它们的关系是这样的：

> A buffer is the in-memory text of a file. A window is a viewport on a buffer. A tab page is a collection of windows. –vimdoc

+ 分屏打开多个文件
使用-O参数可以让Vim以分屏的方式打开多个文件：

`vim -O main.cpp my-oj-toolkit.h`

使用小写的-o可以水平分屏。

+ 打开关闭命令
在进入Vim后，可以使用这些命令来打开/关闭窗口：

```
:sp[lit] {file}     水平分屏
:new {file}         水平分屏
:sv[iew] {file}     水平分屏，以只读方式打开
:vs[plit] {file}    垂直分屏
:clo[se]            关闭当前窗口
```

上述命令中，如未指定file则打开当前文件。

+ 切换窗口
切换窗口的快捷键就是Ctrl+w前缀 + hjkl：

```
Ctrl+w h        切换到左边窗口
Ctrl+w j        切换到下边窗口
Ctrl+w k        切换到上边窗口
Ctrl+w l        切换到右边窗口
Ctrl+w w        遍历切换窗口
```

+ 移动窗口
分屏后还可以把当前窗口向任何方向移动，只需要将上述快捷键中的hjkl大写：

```
Ctrl+w H        向左移动当前窗口
Ctrl+w J        向下移动当前窗口
Ctrl+w K        向上移动当前窗口
Ctrl+w L        向右移动当前窗口
```
+ 调整大小
调整窗口大小的快捷键仍然有Ctrl+W前缀：

```
Ctrl+w +        增加窗口高度
Ctrl+w -        减小窗口高度
Ctrl+w =        统一窗口高度
```

## 执行外部命令 exec external cmd

执行外部命令	:!<cmd> 执行外部命令 <cmd>	在正常模式下输入该命令

显示命令行命令历史	q: 显示命令行命令历史的窗口	可以选择重用以前用过的命令行命令

其中命令 q:会显示使用过的行命令历史，可以从中选择重用以前用过的命令。这对于需要重复应用那些复杂的命令来说，非常方便快捷。

## 插件

### 起始屏替换

> [startify](https://github.com/mhinz/vim-startify)

> A fancy start screen for Vim.

一个漂亮的起始屏。

> This plugin provides a start screen for Vim and Neovim.
> It provides dynamically created headers or footers and uses configurable lists to show recently used or bookmarked files and persistent sessions. All of this can be accessed in a simple to use menu that even allows to open multiple entries at once.
> Startify doesn't get in your way and works out-of-the-box, but provides many options for fine-grained customization.

开箱即用的开屏插件，提供了一个简单的菜单来显示最近编辑的文件、回话等历史记录，并提供了细粒度的选项配置；

+ 如需定制可以查看：

```
:h startify
:h startify-faq
```


### 自动保存编辑内容

> [vim-auto-save](https://github.com/907th/vim-auto-save)

AutoSave - automatically saves changes to disk without having to use :w (or any binding to it) every time a buffer has been modified or based on your preferred events.

在任何缓冲区内容发生修改的时候主动存盘；

+ 激活插件  

> AutoSave is disabled by default, run :AutoSaveToggle to enable/disable it.

插件默认关闭，使用 `:AutoSaveToggle` 启用或者停用；

+ 设置默认启用

> If you want the plugin to be enabled on startup use the g:auto_save option.

```vi
" .vimrc
let g:auto_save = 1  " enable AutoSave on Vim startup
```

配置上面选项将会在 vim 打开伊始就启用插件；


### 配色方案

> [hybrid.vim](https://github.com/w0ng/vim-hybrid)

一个黑色主题的配色方案，让 window 间的分割线更顺眼；

+ 推荐配置

> Due to the limited 256 palette, colours in Vim and gVim will still be slightly different.

> In order to have Vim use the same colours as gVim (the way this colour scheme is intended) define the basic 16 colours in your terminal.

1. 在 iterm2 import [颜色预设](https://raw.githubusercontent.com/w0ng/dotfiles/master/iterm2/hybrid.itermcolors)；

2. 添加配置到 `~/.vimrc`

```vi
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid
```


### 输入法切换

> [Mac Vim IdeaVim Esc 命令行模式自动切换英文输入法问题](https://www.yuanmomo.net/2019/08/31/mac-vim-input-method-problem/)

1. 依赖 `im-select` 插件来拿到和设置系统的输入法

安装这个插件之后可以使用：

```bash
❯ curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh
* Downloading im-select...
* im-select is installed!
*
*
*
* now run "im-select" in your terminal!
❯ im-select
com.apple.keylayout.ABC
❯ im-select
com.baidu.inputmethod.BaiduIM.pinyin
❯ ls /usr/local/bin/ | grep im-sele
im-select
❯ im-select com.apple.keylayout.ABC
❯ im-select com.baidu.inputmethod.BaiduIM.pinyin
```

安装插件；
查看当前的输入法；
切换输入法之后在查看；
就得到了系统的两个输入法的 _id_ ；
最后设置一下输入法试试插件是否生效；

2. 依赖 [ybian/smartim](https://github.com/ybian/smartim)

_这个插件只支持 MacOS，因为上面个插件调用的是 mac 的 api_

```vimrc
" 自动切换输入法
Plug 'ybian/smartim'
" 设置默认输入法
let g:smartim_default = 'com.apple.keylayout.ABC'
```


### NERDTree

+ 安装

```sh
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
```

+ 基本使用

> [使用 NERDTree 来实现文件目录管理](https://www.imooc.com/video/19465)
> [如何优雅地使用 VIM 文件管理插件 NERDTree](https://linux.cn/article-7424-1.html)

在 NERDTree 操作区的一些基本操作：

```md
?: 快速帮助文档
o: 打开一个目录或者打开文件，创建的是 buffer，也可以用来打开书签
go: 打开一个文件，但是光标仍然留在 NERDTree，创建的是 buffer
t: 打开一个文件，创建的是Tab，对书签同样生效
T: 打开一个文件，但是光标仍然留在 NERDTree，创建的是 Tab，对书签同样生效
i: 水平分割创建文件的窗口，创建的是 buffer
gi: 水平分割创建文件的窗口，但是光标仍然留在 NERDTree
s: 垂直分割创建文件的窗口，创建的是 buffer
gs: 和 gi，go 类似
x: 收起当前打开的目录
X: 收起所有打开的目录
e: 以文件管理的方式打开选中的目录
D: 删除书签
P: 大写，跳转到当前根路径
p: 小写，跳转到光标所在的上一级路径
K: 跳转到第一个子路径
J: 跳转到最后一个子路径
<C-j> 和 <C-k>: 在同级目录和文件间移动，忽略子目录和子文件

# 家或者说工作区的概念
cd: 设置常用工作区
CD：返回到使用 cd 设置的常用工作区；

#  根的概念
C: 将根路径设置为光标所在的目录
u: 设置上级目录为根路径

# 对目录进行修改
m    文件操作：复制、删除、移动等

# 目录间移动
U: ~~设置上级目录为跟路径，但是维持原来目录打开的状态~~ 跳转到上一层目录
O       递归打开选中 结点下的所有目录

r: 刷新光标所在的目录
R: 刷新当前根路径
I: 显示或者不显示隐藏文件
f: 打开和关闭文件过滤器
q: 关闭 NERDTree
A: 全屏显示 NERDTree，或者关闭全屏

# 其他操作

!       执行当前文件
```
+ 切换标签页
```vim
:tabnew [++opt选项] ［＋cmd］ 文件      建立对指定文件新的tab
:tabc   关闭当前的 tab
:tabo   关闭所有其他的 tab
:tabs   查看所有打开的 tab
:tabp   前一个 tab
:tabn   后一个 tab

#标准模式下：
gT      前一个 tab
gt      后一个 tab
```
> [NerdTree的美化](https://segmentfault.com/a/1190000015143474)


### ctrlpvim/ctrlp.vim

[ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

+ 设置

添加快捷键映射，调起插件进行检索 `let g:ctrlp_map = '<c-p>'` ;

只能在文件根目录进行检索；

+ 使用

利用 ctrlp 打开文件，之后使用 NERDTree <leader>v 快速定位文件在目录树的位置；


### LeaderF

> [LeaderF 插件使用](https://xudeyu.github.io/2019/04/03/vim-leaderf.html)

+ 检索文件：`<leader>f`

+ 检索 buffer：`<leader>b`

+ 在 LeaderF 运行起来以后（在正常检索的模式下），可以执行下面的一些操作：

```
<C-C>, <ESC> : 退出 LeaderF.
<C-R> : 在模糊匹配和正则式匹配之间切换
<C-F> : 在全路径搜索和名字搜索之间切换
<Tab> : 在检索模式和选择模式之间切换
<C-J>, <C-K> : 在结果列表里选择
<C-X> : 在水平窗口打开
<C-]> : 在垂直窗口打开
<C-T> : 在新标签打开
<C-P> : 预览结果
```


### YouCompleteMe

> [Vim自动补齐插件YouCompleteMe安装指南(2019年最新)-Vim插件(15)](https://vimjc.com/vim-youcompleteme-install.html)

### snippets 代码片段相关

> [UltiSnips](https://github.com/SirVer/ultisnips)

> UltiSnips - The ultimate snippet solution for Vim. Send pull requests to SirVer/ultisnips!

宣称是最终版片段提示解决方案；

+ 配置

如果需要和 `YouCompleteMe` 一起使用，就需要把下面的 `tab` 映射替换成其他键；

```
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
```

+ 使用

```
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
```

使用 `<c-b>` 向前替换代码片段中的占位符，直到 `$0` 占位符（即结束片段编码）；
使用 `<c-z>` 向后重新修改前一个占位符内容；

+ 查询支持的片段 `/Users/jiiiiiin/.vim/plugged/vim-snippets/UltiSnips`

+ 自定义片段

如自定义一个 markdown 的代码片段：

```
~/Documents/LearnDatas/note master ⇡1 !2 ?1
❯ mkdir ~/.vim/UltiSnips/

~/Documents/LearnDatas/note master ⇡1 !2 ?1
❯ cp ~/.vim/plugged/vim-snippets/UltiSnips/markdown.snippets ~/.vim/UltiSnips/
```

如果需要「在 .vimrc 文件中指定代码片段搜索文件夹。let g:UltiSnipsSnippetDirectories=["UltiSnips","mysnippets"]」。

读取Ultisnips的路径是~/.vim/UltiSnips，但是插件安装的目录会自己解决相应问题，所以自定义片段就可以放在默认目录；

新增自定义片段：

```
# 自定义下面连个片段的别名

snippet ci "Inline Code" i
\`$1\`$0
endsnippet

snippet cb "Codeblock" b
\`\`\`
$1
\`\`\`
$0
endsnippet
```

大致语法：

```
snippet <name>
<body>
endsnippet
```


### 其他待整理插件 Other Plugins

### vim-autoformat

> [Vim代码格式化插件vim Autoformat](https://wsxq2.55555.io/blog/2018/11/25/Vim代码格式化插件vim-autoformat/)
> [在 VIM 下写 C++ 能有多爽？](https://harttle.land/2015/07/18/vim-cpp.html)



## 安装 vim

> [Mac自带的Vim怎么升级？](https://www.zhihu.com/question/34113076)

最好是不要动系统自带的 vim，重新装一个，之后用别名映射方式替代系统的 `vi/vim` 指令；

```bash
# 查看待安装软件信息
brew info macvim
# 主要是看目前系统是否安装了、需要哪些依赖、必备条件

# 安装
brew install macvim
# 安装位置 /usr/local/Cellar/macvim/8.1-161

echo "alias vi=vim" > ~/.zshrc
# 统一系统终端下 vi/vim

❯ type vim
vim is /usr/local/bin/vim
# 检查当前 vim 命令所在目录，如果还是系统自带的,❯ /usr/bin/vim --version ,就需要 source 一下环境配置文件或者重新开一个终端

❯ ls -ld /usr/local/bin/vim
lrwxr-xr-x  1 jiiiiiin  admin  32 Feb 18 00:28 /usr/local/bin/vim -> ../Cellar/macvim/8.1-161/bin/vim
# 从上面看出 berw 安装完成之后会在 local/bin 下 link 一个 macvim

```

> [mac下配置vim](https://www.jianshu.com/p/923aec861af3)

+ 查看配置文件信息 

`:version` 进入 vim，[配置文件](https://www.jianshu.com/p/923aec861af3)，一般使用家目录中的`~/.vimrc` 来进行 vim 的配置；


+ 查看配置加载优先级

`:scriptname` 查看各脚本的加载顺序;
用户配置文件中的配置会覆盖全局配置文件的配置；因此，我们可以通过创建~/.vimrc来修改vim的默认配置;

+ 保存后自动应用配置

`autocmd bufwritepost .vimrc source $MYVIMRC` 添加到 vim配置文件中；

+ [显示中文帮助](https://www.jianshu.com/p/923aec861af3)

## 配置 Config
    
    Vi/Vim 有很多内部变量，可以根据需要进行相应的设置。变量类型不同往往设置方式也不一样，简单的只要设置特定的变量名即可，复杂的则需要指定和分配一个显式值来设置变量。在实际应用中，如果有需要，请参考 Vi/Vim 的使用手册。

> [Vim 配置入门](http://www.ruanyifeng.com/blog/2018/09/vimrc.html)

> [Vi/Vim 设置](https://www.ibm.com/developerworks/cn/linux/l-cn-tip-vim/index.html)

> [k-vim](https://github.com/wklken/k-vim/blob/master/vimrc)


> [Vim初级：配置和使用](https://harttle.land/2013/11/08/vim-config.html)

> [语法高亮相关][https://harttle.land/2015/07/17/vim-advanced.html#header-3]

> [缩进设置][https://harttle.land/2015/07/17/vim-advanced.html#header-6]

+ 查询某个配置项是打开还是关闭，可以在命令模式下，输入该配置，并在后面加上问号。

`:set number?`

上面的命令会返回number或者nonumber。

如果想查看帮助，可以使用help命令。

`:help number`



+ 更新 vim 配置文件 `:so $MYVIMRC`

### 键盘映射

> [键盘映射][https://harttle.land/2015/07/17/vim-advanced.html#header-8]

Vim支持定义键盘映射来完成快捷键的功能，也就是将特定的按键映射为一系列按键与函数的序列。

例如将 `F7` 映射为编译当前 java 文件：

```vim
map <F7> <Esc>:!javac %<<CR>
```

`:` 为进入Ex模式，`!` 指定下面的命令在vim外执行，`%` 为当前文件名，`%<` 为不带扩展名的当前文件名，`<CR>` 为回车。

此外设置 `map` 时可以指定它在何种情况（Vim 模式）下生效，这些模式包括：

map 模式 | 描述
:---:  | ----
n	|	普通
v	|	可视和选择
s	|	选择
x	|	可视
o	|	操作符等待
!	|	插入和命令行
i	|	插入
l	|	插入、命令行和 Lang-Arg 模式的 ":lmap" 映射
c	|	命令行


定义 `map` 时添加上述模式名作为前缀，即可指定 `map` 命令在哪些模式生效：

命令    |       左边  |       右边   |          模式
----    | -------     |     ----     |           ----
:map     |    {lhs}  |   {rhs}  |       mapmode-nvo
:nm[ap]  |  {lhs}    |  {rhs}    |    mapmode-n
:vm[ap]  |  {lhs}    |  {rhs}    |    mapmode-v
:xm[ap]  |  {lhs}    |  {rhs}    |    mapmode-x
:smap    |   {lhs}   |   {rhs}   |    mapmode-s
:om[ap]  |  {lhs}    |  {rhs}    |    mapmode-o
:map!    |   {lhs}   |   {rhs}   |    mapmode-ic
:im[ap]  |   {lhs}   |   {rhs}   |    mapmode-i
:lm[ap]  |   {lhs}   |   {rhs}   |    mapmode-l
:cm[ap]  |  {lhs}    |  {rhs}    |    mapmode-c

此外还可添加`nore` 指定非递归方式（取消传递性）。
例如 `inoremap` 为插入模式下工作的 `map`，并且它的值不会被递归映射。

> 参考：[Mapping keys in Vim - Tutorial](http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_1%29)



## 模式 mode

与大部分其它编辑器不同，进入 Vim 后，缺省状态下键入的字符并不会插入到所编辑的文件之中。Vim 的模式（mode，可以简单地理解为“状态”）概念非常重要。需要知道，Vim 有以下几个模式：

+ 正常（normal）模式，缺省的编辑模式；下面如果不加特殊说明，提到的命令都直接在正常模式下输入；任何其它模式中都可以通过键盘上的 Esc 键回到正常模式。
+ 命令（command）模式，用于执行较长、较复杂的命令；在正常模式下输入“:”（一般命令）、“/”（正向搜索）或“?”（反向搜索）即可进入该模式；命令模式下的命令要输入回车键（Enter）才算完成。
+ 插入（insert）模式，输入文本时使用；在正常模式下键入“i”（insert）或“a”（append）即可进入插入模式（也有另外一些命令，如“c”，也可以进入插入模式，但这些命令有其它的作用）。
+ 可视（visual）模式，用于选定文本块；可以在正常模式下输入“v”（小写）来按字符选定，输入“V”（大写）来按行选定，或输入“Ctrl-V”来按方块选定。
+ 选择（select）模式，与普通的 Windows 编辑器较为接近的选择文本块的方式；在以可视模式和选择模式之一选定文本块之后，可以使用“Ctrl-G”切换到另一模式——该模式很少在 Linux 上使用，本文中就不再介绍了。

## 函数

现在我们可以自定义快捷键了，如果希望在键盘映射中执行更复杂的功能，我们需要定义Vim函数。

* 函数名必须以大写字母开始
* 函数可以有返回值：`return something`
* 函数可以有范围前缀。定义：`function s:Save()`，调用：`call s:Save()`

下面是函数调用的例子，按键F8时，进入拷贝模式（取消行号，鼠标进入visual模式）。

```vim
" key mapping
map <F8> <Esc>:call ToggleCopy()<CR>

" global variable
let g:copymode=0

" function
function ToggleCopy()
    if g:copymode
        set number
        set mouse=a
    else
        set nonumber
        set mouse=v
    endif
    let g:copymode=!g:copymode
endfunction
```

> 参考：[Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com/chapters/23.html)

## 录制宏

用户录制的宏保存在寄存器中，我们先来看看什么是寄存器。vim的寄存器分为数字寄存器和字母寄存器。

* 数字寄存器为`0-9`，`0`保存着上次复制的内容，`1-9`按照最近的顺序保存着最近删除的内容。
* 字母寄存器为`a-z`，拷贝3行到寄存器`c`：`c3yy`.

现在开始录制宏。假如有如下的文件，我们希望将第二列的类型用`` ` ``分隔起来。

```
1 | BOOL  | Boolean
2 | SINT  | Short integer
3 | INT   | Integer 
4 | DINT  | Double integer 
5 | LINT  | Long integer 
6 | USINT | Unsigned short integer 
7 | UINT  | Unsigned integer 
```

1. 首先按几次`<Esc>`进入normal模式，光标移到第一行，开始录制并存入m寄存器`qm`。
2. 光标到行首`^`，到第二列词首`ww`，进入插入模式`i`，插入分隔符`` ` ``，退出到normal模式`<Esc>`，到词尾`e`，进入插入模式`i`，插入分隔符`` ` ``，退出到normal模式`<Esc>`，光标到下一行`j`。
3. 结束录制`q`。
4. 光标到第二行，在normal模式执行100次寄存器m中的宏`100@m`。

宏会在 `j` 执行错误后自动结束，得到如下文件：

```
1 | `BOOL`  | Boolean
2 | `SINT`  | Short integer
3 | `INT`   | Integer 
4 | `DINT`  | Double integer 
5 | `LINT`  | Long integer 
6 | `USINT` | Unsigned short integer 
7 | `UINT`  | Unsigned integer 
```
