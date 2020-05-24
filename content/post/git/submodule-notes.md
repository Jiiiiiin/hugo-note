---
title: "Git Submodule Notes"
date: 2020-02-17T15:42:15+08:00

tags: ["Git"]
categories: ["Git"]
draft: true
---
 
Git Submodule 学习记录
<!--more-->

> [官方教程](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)

> [使用Git Submodule管理子模块](https://segmentfault.com/a/1190000003076028)
> [git submodules - Git diff表示子项目很脏](https://www.itranslater.com/qa/details/2120446891300226048)

## 常用命令

```bash
# 添加自模块
# 首先应当注意到新的 .gitmodules 文件。 该配置文件保存了项目 URL 与已经拉取的本地目录之间的映射
# 如果有多个子模块，该文件中就会有多条记录。 要重点注意的是，该文件也像 .gitignore 文件一样受到（通过）版本控制。 它会和该项目的其他部分一同被拉取推送。 这就是克隆该项目的人知道去哪获得子模块的原因。
# 虽然 DbConnector 是工作目录中的一个子目录，但 Git 还是会将它视作一个子模块。当你不在那个目录中时，Git 并不会跟踪它的内容， 而是将它看作子模块仓库中的某个具体的提交。
git submodule add https://github.com/chaconinc/DbConnector [rename-folder]

git diff --cached --submodule
git diff --submodule

# 克隆含有子模块的项目
# 其中有 DbConnector 目录，不过是空的。 你必须运行两个命令：git submodule init 用来初始化本地配置文件，而 git submodule update 则从该项目中抓取所有数据并检出父项目中列出的合适的提交。
# 不过还有更简单一点的方式。 如果给 git clone 命令传递 --recurse-submodules 选项，它就会自动初始化并更新仓库中的每一个子模块， 包括可能存在的嵌套子模块。
git clone --recurse-submodules https://github.com/chaconinc/MainProject
#如果你已经克隆了项目但忘记了 --recurse-submodules，那么可以运行 git submodule update --init 将 git submodule init 和 git submodule update 合并成一步。如果还要初始化、抓取并检出任何嵌套的子模块， 请使用简明的 git submodule update --init --recursive。

# 如果想要在子模块中查看新工作，可以进入到目录中运行 git fetch 与 git merge，合并上游分支来更新本地代码。
$ git fetch
$ git merge origin/master

# 当运行 git submodule update --remote 时，Git 默认会尝试更新 所有 子模块， 所以如果有很多子模块的话，你可以传递想要更新的子模块的名字。
git submodule update --remote

```




## 适用场景

1. 比如 Hugo 在添加主题的时候，建议将主题以 Submodule 的方式添加到仓库，方便之后的主题升级；
2. 比如项目上有一个 lib 项目，多个应用都需要依赖这个 lib 项目，那么 lib 的同步就可以使用这里的 Submodule，当然把 lib 独立发布，然后通过 mavem 或者 gradle 的方式进行依赖会是更好的做法；

如果使用 Submodule 来管理我们就可以解决以下几点问题：

+ 如何在git项目中导入library库?
+ library库在其他的项目中被修改了可以更新到远程的代码库中?
+ 其他项目如何获取到library库最新的提交?
+ 如何在clone的时候能够自动导入library库?
+ 解决以上问题，可以考虑使用git的 Submodule来解决。

> Git 通过子模块来解决这个问题。 子模块允许你将一个 Git 仓库作为另一个 Git 仓库的子目录。 它能让你将另一个仓库克隆到自己的项目中，同时还保持提交的独立。


_以 Hugo 添加一个主题为例：_ 


## _添加子模块_ 

`git clone https://github.com/olOwOlo/hugo-theme-even themes/even` 

添加主题;

```bash
❯ g status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   ../.gitmodules
	new file:   themes/even
```

可以看到根目录中多了一个文件,这个文件用来保存子模块的信息。

## 查看子模块

```bash
❯ g submodule
 d39d3e443953caea05510b19fdd7a259c71a0ab3 sub/themes/even (v4.0.0-21-gd39d3e4)
```

## 更新子模块

```bash
# Git 将会进入子模块然后抓取并更新，默认更新master分支
git submodule update --remote
```

更新主题，如果主题发布了新版本;

## 克隆包含子模块的项目

[Git submodule 子模块的管理和使用](https://www.jianshu.com/p/9000cd49822c)

