---
title: "Brew Note"
date: 2020-02-16T23:10:12+08:00

tags: ["mac-os", "brew"]
categories: ["mac-os"]
draft: true
---

## 配置

### 修改镜像源

使用下面的命令替换 brew 源为 [中科大镜像](https://link.zhihu.com/?target=https%3A//lug.ustc.edu.cn/wiki/mirrors/help/brew.git)

```bash
# 替换brew.git:
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

# 替换homebrew-core.git:
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
```

## 插件

### Ranger

> [把你的终端变成逆天高效神器：Ranger终极配置方案～](https://www.bilibili.com/video/av64990176)


```zsh
移动上一层的文件夹列表：[|]
使用左右中括号来移动；

退回和前进：shift+H/shift+L

给文件排序：按下 o，之后按需要的排序策略进行，比如再按一个 s
就可以按文件大小排序；

检索文件，按/键；
快速检索结果使用 n 和 vim 类似；

使用 shift+s 就可以将当前的 shell 中的工作路劲修改为当前 ranger 选中的文件夹；

按 yp 可以复制当前选中文件的路径；
其实 y 是一个“前缀”，可以按yn复制文件名；

重命名文件按一下a；

复制文件使用yy，粘贴文件使用pp；
p也是一个前缀，比如po可以进行文件覆盖；

dd就是剪切；

删除文件，dD+回车确认；

按 zh显示隐藏文件

选中文件按 i 进行全屏预览，或者直接回车可以使用对应类型的程序打开文件；

重命名文件夹：cw；
重命名文件：a、I、A在不同的位置进行文件的重命名；


批量重命名：按 :bulkrename，或者可以按 cw 可以进入 vim
中进行编辑（重命名），退出之后就被重命名了；

W 进入任务管理器；
dd 可以取消一个任务；

可以使用 compress压缩选中的文件；
先使用 yy 复制一下文件，再使用 extracthere 来解压缩；
被映射成 C/X；

# 自定义快捷键
M 创建文件夹；
V/T 来新建文件；
```

+ 自定义配置 rc.conf

```bash
# ===
# Custom Config
# ===

map V console shell nvim%space 
map T console shell touch%space 
map M console mkcd%space
map C console compress%space
map X console extracthere%space

# plugin
map cj console j%space
```


### fzf

> [FZF：终端下的文件查找器【猛男必备233333】](https://www.bilibili.com/video/av80254519)
>



