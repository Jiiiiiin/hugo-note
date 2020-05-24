---
title: "Common Commands Notes"
date: 2020-03-14T14:33:34+08:00
tags: ["git"]
categories: ["git"]

draft: true
---

<!-- vim-markdown-toc GFM -->

* [常用命令 Common Commands](#常用命令-common-commands)

<!-- vim-markdown-toc -->

## 常用命令 Common Commands

> [命令查询](https://cloud.tencent.com/developer/section/1138689)


```git
# 工作流

## ==== 本地开发

## 工作区和暂存区
g diff <filename>

## --跨分支

g diff <branch> <filename>

## 暂存区和远程仓库
g diff --cached <commit> <filename>

## 两个commit之间

g diff <commit> <commit>

## ==== 远程同步

## 将远程代码进行同步
g fetch origin[/BRANCH_NAME]

## 对比本地分支和fetch的远程对应分支代码不同
g diff master origin/master

## 图形化对比
g difftool -y master origin/master

## 如果没有冲突就直接rebase
g rebase origin/master

## 如果有冲突就直接
g mergetool -y master origin/master

# 分支相关

## 删除远程分支
git branch -r -d origin/branch-name
git push origin :branch-name

# ==== 操作失误相关～～

## 删除工作区未暂存的所有文件，这里的-n用来看看会删除哪些文件，避免误删
g clean -nf
### 连目录一起
g clean -nfd


```



