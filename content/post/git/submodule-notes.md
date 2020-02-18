---
title: "Git Submodule Notes"
date: 2020-02-17T15:42:15+08:00

tags: ["Git"]
categories: ["Git"]
---
 
Git Submodule 学习记录
<!--more-->

> [使用Git Submodule管理子模块](https://segmentfault.com/a/1190000003076028)

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

