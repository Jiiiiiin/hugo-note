---
title: "Vim Is Common Use Cmd Notes"
date: 2020-02-16T11:29:13+08:00

tags: ["Vim"]
categories: ["Vim"]
---

记录自己使用 `vim` 的一些总结。
<!--more-->

## Tips

### 配置相关

+ 更新 vim 配置文件 `:so $MYVIMRC`


### 撤消与重做

+ u 撤消更改
+ Ctrl-R 重做更改

### 交换相邻字符或行

+ xp 交换光标位置的字符和它右边的字符
+ ddp 交换光标位置的行和它的下一行

### 大小写转换

+ ~ 将光标下的字母大小写反向转换
+ guw 将光标所在的单词变为小写
+ guw 将光标所在的单词变为小写
+ gUw 将光标所在的单词变为大写
+ guu 光标所在的行所有字符变为小写
+ gUU 光标所在的行所有字符变为大写
+ `g~~ 光标所在的行所有字符大小写反向转换`


### 缩进

+ `>> 右缩进（可配合操作数使用）`
+ `<< 左缩进（可配合操作数使用）`

### 临时退出 vim 回到 shell

1. 使用 Ctrl-z 以及 fg 这两个命令组合

这一解决方法主要利用了 Linux/Unix 的作业机制。具体原理是：Ctrl-z 命令将当前的 Vi/Vim 进程放到后台执行，之后 shell 环境即可为你所用；fg 命令则将位于后台的 Vi/Vim 进程放到前台执行，这样我们就再次进入 Vi/Vim 操作界面并恢复到原先的编辑状态。

2. 使用行命令 :sh

在 Vi/Vim 的正常模式下输入 :sh即可进入 Linux/Unix shell 环境。在要返回到 Vi/Vim 编辑环境时，输入 exit 命令即可。

　　这两种方法实现机制不一定，但效果一样，都非常快捷有效。

## 移动光标

Vi/Vim 中关于光标移动的命令非常多，这也是很多人经常困惑并且命令用不好的地方之一。其实 Vi/Vim 中很多命令是针对不同的操作单位而设的，不同的命令对应不同的操作单位。因而，在使用命令进行操作的时候，首先要搞清楚的就是要采用哪种操作单位，也就是说，是要操作一个字符，一个句子，一个段落，还是要操作一行，一屏、一页。单位不同，命令也就不同。只要单位选用得当，命令自然就恰当，操作也自然迅速高效；否则，只能是费时费力。这也可以说是最能体现 Vi/Vim 优越于其它编辑器的地方之一，也是 Vi/Vim 有人爱有人恨的地方之一。在操作单位确定之后，才是操作次数，即确定命令重复执行的次数。要正确高效的运用 Vi/Vim 的各种操作，一定要把握这一原则：先定单位再定量。操作对象的范围计算公式为：操作范围 = 操作次数 * 操作单位。比如：5h 命令左移 5 个字符，8w 命令右移 8 个单词。

Vi/Vim 中操作单位有很多，按从小到大的顺序为（括号内为相应的操作命令）：字符（h、l）→ 单词 (w、W、b、B、e) → 行 (j、k、0、^、$、:n) → 句子（(、)）→ 段落（{、}）→ 屏 (H、M、L) → 页（Ctrl-f、Ctrl-b、Ctrl-u、Ctrl-d) → 文件（G、gg、:0、:$）。

## 文本编辑

　　与光标移动一样，Vi/Vim 中关于编辑操作的命令也比较多，但操作单位要比移动光标少得多。按从小到大的顺序为（括号内为相应的操作命令）：字符 （x、c、s、r、i、a）→ 单词 (cw、cW、cb、cB、dw、dW、db、dB) → 行 (dd、d0、d$、I、A、o、O) → 句子（(、)）→ 段落（{、}）。这些操作单位有些可以加操作次数。操作对象的范围计算公式为：操作范围 = 操作次数 * 操作单位。比如：d3w 命令删除三个单词，10dd 命令删除十行。


> [技巧：快速提高 Vi/Vim 使用效率的原则与途径](https://www.ibm.com/developerworks/cn/linux/l-cn-tip-vim/index.html)

+ 指令代指

```bash
i: insert
a: append
o: open a line below
```


## 分屏

+ 分屏启动Vim

使用大写的O参数来垂直分屏。

`vim -On file1 file2 ...`

使用小写的o参数来水平分屏。

`vim -on file1 file2 ...`

> 注释: n是数字，表示分成几个屏。

+ 窗口内分屏

上下分割当前打开的文件。

`Ctrl+W s`

上下分割，并打开一个新的文件。

`:sp filename`

左右分割当前打开的文件。

`Ctrl+W v`

左右分割，并打开一个新的文件。

`:vsp filename`

+ 关闭当前窗口 `<C+w> c`
+ 关闭 buffer 而不关闭窗口（window）`:bd`
+ 查看所有缓冲区 `:ls`，输入`:b <filename or number>` 切换到一个已开启的缓冲区（可使用自动补全）： 

```vim
:ls
1   a + "i.py"          line0
3   %a=+ "j.py"         line3
5   #a    "k.py"            line1

:b 1
:b k.py 
```


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

1. 依赖 `im-select` 插件来拿到和设置系统的输入法，一般习惯系统就装两个输入法，sugo 输入法功能太多，不好驾驭，我选择 baidu 输入法，这里；

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

建议先查一下自己的英文输入法，因为插件默认认为你的英文输入法 id 是 `US English (com.apple.keylayout.US)` ，其实好像也没啥用，因为设置了_jj_ 作为<Esc> 的替代，连打的时候，回顺手勾一下右边的 shift 键，再按_jj_ ，所以在进入普通模式的时候，自己其实已经切换了英文，进入插入模式之后，使用一个 _Kawa_ 的改键软件快速在切一下中文，其实也还好，另外百度输入法的英文模式支持 vim 中使用，效果就类似 ABC 输入法，这样只要每次右边小拇指切一下 shift 就可以了。



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
C: 将根路径设置为光标所在的目录
u: 设置上级目录为根路径
U: 设置上级目录为跟路径，但是维持原来目录打开的状态
r: 刷新光标所在的目录
R: 刷新当前根路径
I: 显示或者不显示隐藏文件
f: 打开和关闭文件过滤器
q: 关闭 NERDTree
A: 全屏显示 NERDTree，或者关闭全屏
```

### ctrlpvim/ctrlp.vim

[ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

+ 设置

添加快捷键映射，调起插件进行检索 `let g:ctrlp_map = '<c-p>'` ;

只能在文件根目录进行检索；

+ 使用

利用 ctrlp 打开文件，之后使用 NERDTree <leader>v 快速定位文件在目录树的位置；


### YouCompleteMe

> [Vim自动补齐插件YouCompleteMe安装指南(2019年最新)-Vim插件(15)](Vim自动补齐插件YouCompleteMe安装指南(2019年最新)-Vim插件(15))

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

