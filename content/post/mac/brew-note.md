---
title: "Brew Note"
date: 2020-02-16T23:10:12+08:00

tags: ["mac-os", "brew"]
categories: ["mac-os"]
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


