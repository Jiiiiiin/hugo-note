---
title: "Basic Use Notes"
date: 2020-03-30T15:23:49+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [常用快捷键](#常用快捷键)
* [配置](#配置)
* [插件](#插件)
    * [Enhanced Class Decompiler](#enhanced-class-decompiler)
    * [subclipse](#subclipse)
* [下载](#下载)

<!-- vim-markdown-toc -->

> [ Eclipse 教程](https://www.runoob.com/eclipse/eclipse-install.html)

## 常用快捷键

```bash

整段注释：
注释：【Ctrl】+【Shift】+【/】
反注释：【Ctrl】+【Shift】+【\

单行注释：
注释：【Ctrl】+【/】
反注释：【Ctrl】+【/】

格式化代码：
【Ctrl】+【Shitf】+【F】

ctrl+shift+r：打开资源

ctrl+o：快速outline

ctrl+e：快速转换编辑器

ctrl+2，L：为本地变量赋值 开发过程中，我常常先编写方法，如Calendar.getInstance()，然后通过ctrl+2快捷键将方法的计算结果赋值于一个本地变量之上。 这样我节省了输入类名，变量名以及导入声明的时间。Ctrl+F的效果类似，不过效果是把方法的计算结果赋值于类中的域。

alt+shift+r：重命名

alt+shift+l以及alt+shift+m：提取本地变量及方法
    源码处理还包括从大块的代码中提取变量和方法的功能。比如，要从一个string创建一个常量，那么就选定文本并按下alt+shift+l即可。如果同
    一个string在同一类中的别处出现，它会被自动替换。方法提取也是个非常方便的功能。将大方法分解成较小的、充分定义的方法会极大的减少复杂度，并提
    升代码的可测试性。


7. shift+enter及ctrl+shift+enter

    Shift+enter在当前行之下创建一个空白行，与光标是否在行末无关。Ctrl+shift+enter则在当前行之前插入空白行。

8. Alt+方向键

    这也是个节省时间的法宝。这个组合将当前行的内容往上或下移动。在try/catch部分，这个快捷方式尤其好使。

 9. ctrl+m

    大显示屏幕能够提高工作效率是大家都知道的。Ctrl+m是编辑器窗口最大化的快捷键。

10. ctrl+.及ctrl+1：下一个错误及快速修改

    ctrl+.将光标移动至当前文件中的下一个报错处或警告处。这组快捷键我一般与ctrl+1一并使用，即修改建议的快捷键。新版Eclipse的修改建 议做的很不错，可以帮你解决很多问题，如方法中的缺失参数，throw/catch exception，未执行的方法等等。

11. ctrl+t会列出接口的实现类列表

12. Alt-left arrow: 在导航历史记录（Navigation History）中后退。就像Web浏览器的后退按钮一样，在利用F3跳转之后，特别有用。（用来返回原先编译的地方） Alt-right arrow: 导航历史记录中向前。

13. Control-Q: 回到最后一次编辑的地方。这个快捷键也是当你在代码中跳转后用的。特别是当你钻的过深，忘记你最初在做什么的时候。

8. Control-Shift-F: CodeàJavaàPreferencesà根据代码风格设定重新格式化代码。我 们的团队有统一的代码格式，我们把它放在我们的wiki上。要这么做，我们打开Eclipse，选择Window Style，然后设置Code Formatter，Code Style和Organize Imports。利用导出（Export）功能来生成配置文件。我们把这些配置文件放在wiki上，然后团队里的每个人都导入到自己的Eclipse中。


Ctrl + Shift + O 快速导入引用包


快捷键：Alf+Shift+A

Toggle Block Selection Mode(块选择模式开关)
```



## 配置

> [比较全面的Eclipse配置详解（包括智能提示设置、智能提示插件修改，修改空格自动上屏、JDK配置、各种快捷键列表……）](https://www.cnblogs.com/decarl/archive/2012/05/15/2502084.html)

> [eclipse工作空间配置导出复制](https://blog.csdn.net/zhangbingtao2011/article/details/88051533)


> [Eclipse快捷键 10个最有用的快捷键](https://www.open-open.com/bbs/view/1320934157953)




> [如何查看class文件的jdk版本](https://blog.csdn.net/gnail_oug/article/details/47145047)

> [eclipse配置JDK和设置编译版本的几种方法](https://blog.csdn.net/gnail_oug/article/details/53610768)

> [eclipse取消默认工作空间的两种方法](https://blog.csdn.net/gnail_oug/article/details/53992580)

> [eclipse中通过Properties Editor插件查看配置文件中Unicode内容](https://blog.csdn.net/gnail_oug/article/details/80680405)

> [eclipse工作空间配置导出复制](https://blog.csdn.net/zhangbingtao2011/article/details/88051533)




## 插件

### Enhanced Class Decompiler

> [Eclipse安装代码反编译插件Enhanced Class Decompiler](https://www.cnblogs.com/modou/p/10860123.html)

### subclipse

> [Eclipse中使用SVN](https://blog.csdn.net/cc20032706/article/details/57074595)
> [eclipse中svn插件的安装与使用](https://wenku.baidu.com/view/52334b2c0066f5335a8121eb.html)
> [JavaHL安装](https://juejin.im/post/5d8dda86e51d4578122d7259)


> [Eclipse 文件搜索排除svn目录](https://blog.csdn.net/WeLoveSunFlower/article/details/44956905)
  + 可以实现排除对应目录或者文件在项目的目录树中显示
  + 检索的时候排除该文件或者目录 TODO

> [设置svn的ignore设置](https://blog.csdn.net/frankcheng5143/article/details/52871205)




## 下载

> [Eclipse 2018-12 (4.10) - 最一个32位版本](https://www.eclipse.org/downloads/packages/release/helios/sr1/eclipse-ide-java-developers)




