---
title: "Linux_permissions_notes"
date: 2020-03-01T15:03:59+08:00
draft: true
---


<!-- vim-markdown-toc GFM -->

* [ACL](#acl)

<!-- vim-markdown-toc -->

## ACL

> [Linux高级权限管理 - ACL [LinuxCast视频教程]](https://www.youtube.com/watch?v=yM34XIW1uuc&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=24)

+ ACL （Access Control List） 是一种高级权限机制，允许我们对一一个文件或文件夹进行灵活的、复杂的权限设置。
+ ACL需要在挂载文件的时候打开ACL功能：
   `mount 一0 acl /dev/sda5 /mnt`

+ ACL允许针对不同用户、不同组对一个目标文件/文件夹进行权限设置，不受UGO模型限制。

![Text](http://qiniu.jiiiiiin.cn/4YtM9k.png)
