---
title: "Github Pages Node"
date: 2020-02-15T22:18:50+08:00
draft: true
---

## Hugo

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


+ theme

> [olOwOlo/hugo-theme-even](https://github.com/olOwOlo/hugo-theme-even/blob/master/README-zh.md)



## 绑定域名到 github 静态 blog 仓库

[github怎么绑定自己的域名？](https://www.zhihu.com/question/31377141)
