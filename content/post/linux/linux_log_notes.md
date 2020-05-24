---
title: "Linux_log_notes"
date: 2020-03-14T22:40:44+08:00
draft: true
---


<!-- vim-markdown-toc GFM -->

* [日志基本概念及rSyslog服务配置](#日志基本概念及rsyslog服务配置)
    * [rsyslog](#rsyslog)
    * [Facility](#facility)
    * [Priority / Severity Level](#priority--severity-level)
    * [rsyslog配置](#rsyslog配置)

<!-- vim-markdown-toc -->

![Text](http://qiniu.jiiiiiin.cn/8KGbE7.png)

## 日志基本概念及rSyslog服务配置

> [日志基本概念及rSyslog服务配置](https://www.youtube.com/watch?v=FRoMIR4E1tQ&list=PLCJcQMZOafICYrx7zhFu_RWHRZqpB8fIW&index=34)

### rsyslog

![Text](http://qiniu.jiiiiiin.cn/SmRQgR.png)


+ 查看日志服务状态

```bash
[vagrant@localhost ~]$ service rsyslog status
Redirecting to /bin/systemctl status rsyslog.service
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-03-12 03:07:08 UTC; 2 days ago
     Docs: man:rsyslogd(8)
           http://www.rsyslog.com/doc/
 Main PID: 730 (rsyslogd)
   CGroup: /system.slice/rsyslog.service
           └─730 /usr/sbin/rsyslogd -n
```

+ /var/log 中的log默认都是由该服务产生；

    - secure 保存登陆相关信息

### Facility
rsyslog通过Facility概念来定义日志消息的来源，以方便对日志进行分类，facility有以下几种：
- kern 内核消息
- user 用户级消息
- mail 邮件系统消息
- daemon 系统服务消息
- auth 认证系统消息
- syslog 日志系统自身消息
- lpr 打印系统消息
- authpriv权限系统消息
- cron 定时任务消息
- news 新闻系统消息
- uucp uucp系统消息
- ftp ftp服务消息
- local0 ~ local7

对日志消息进行分类；

### Priority / Severity Level
除了日志来源以外，对于同一来源产生的日志消息，还进行了优先级划分，优先级分为以下几种： 
+ Emergency 系统已经不可用
+ Alert 必须立即进行处理
+ Critical 严重错误
+ Error 错误
+ Warning 警告
+ Notice 正常信息、但是较为重要
+ Informational 正常信息
+ Debug debug信息

类比日志级别；

### rsyslog配置

![Text](http://qiniu.jiiiiiin.cn/aaKlI1.png)

+ 示例中定义所有mail类的进程所有级别的日志都记录到 maillog中；
+ 第二条是定义所有info级别 TODO 除了mail等服务的日志都记录到messages文件中；
![Text](http://qiniu.jiiiiiin.cn/eaBrtn.png)
+ 自定义配置：
![Text](http://qiniu.jiiiiiin.cn/217Lxw.png)
+ 最后一个示例就是将主机日志转发到专门的日志服务器






