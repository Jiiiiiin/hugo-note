---
title: "Vim Xptemplate Code Snippets Node"
date: 2020-02-15T22:30:14+08:00
draft: true
---

## 基本使用

[在vim中用xptemplate做代码补全](https://github.com/huaoguo/huaoguo.github.com/blob/master/_posts/2014-04-08-%E5%9C%A8vim%E4%B8%AD%E7%94%A8xptemplate%E5%81%9A%E4%BB%A3%E7%A0%81%E8%A1%A5%E5%85%A8.md)

1. 进入 insert 模式，快速连续按下 <C-r><C-r><C-\>
2. 这个菜单是想告诉你，当你输入前面的代码并按下 <C-\> 后，就会自动生成后面的代码
3. 比如你先输入 a，然后按下 <C-\>，就会生成 <a href="href"></a>，并且光标自动停在 href 上，当你键入新内容时 href 会被自动替换，接着按下 <Tab>，光标会自动跳到标签内让你输入链接文本
4. 可以用 <Tab> 和 <S-Tab> 在输入项之间互相切换

---

疑问：

1. 在md 文件格式 link snippet 中最后一个 tab 之后出入完还会剩下一个 `~` 号，怀疑是插件的placeholder ，但是没找到解决方案
