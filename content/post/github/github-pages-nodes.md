---
title: "Github Pages Node"
date: 2020-02-15T22:18:50+08:00
tags: ["hugo", "github-pages"]
categories: ["github"]

draft: true
---

使用`Hugo` 构建一个静态站点，并发布到 GitHub Pages。
<!--more-->

## Hugo

> [ 中文文档](https://www.gohugo.org/doc/)

> [5分钟上手 blog](https://www.gohugo.org/)

```bash
# 本地生成站点源文件夹
hugo new site /path/to/site

cd /path/to/site

# 创建文章
hugo new about.md

# 本地调试
hugo server --theme=hyde --buildDrafts

# 本地静态页面生成
hugo --theme=hyde --baseUrl="http://coderzh.github.io/"

# 上传到 github pages 对应仓库

$ cd public
$ git init
$ git remote add origin https://github.com/coderzh/coderzh.github.io.git
$ git add -A
$ git commit -m "first commit"
$ git push -u origin master
```


### theme

> [olOwOlo/hugo-theme-even](https://github.com/olOwOlo/hugo-theme-even/blob/master/README-zh.md)
> [ahonn/hexo-theme-even](https://github.com/ahonn/hexo-theme-even/wiki)

### 技巧

#### 自定义摘要

```md
 这里就是摘要内容，即下面这个标记之上的文本；
<!--more-->
```

#### 添加菜单

比如添加一个『关于』页面

```md
---
title: "About"
date: 2017-08-20T21:38:52+08:00
lastmod: 2017-08-28T21:41:52+08:00
menu: "main"
weight: 50

---
```

+ 取消当前页面的草稿设置；
+ 设置 menu 为 main；

## 绑定域名到 github 静态 blog 仓库

[github怎么绑定自己的域名？](https://www.zhihu.com/question/31377141)
