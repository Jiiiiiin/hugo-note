---
title: "Internet_finance_platform"
date: 2020-04-14T09:59:58+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [技术架构](#技术架构)
    * [架构分层原则与关键能力集](#架构分层原则与关键能力集)
* [业务架构](#业务架构)
* [k8s](#k8s)

<!-- vim-markdown-toc -->


## 技术架构

### 架构分层原则与关键能力集

+ TODO 分层

+ 关键能力集合





## 业务架构

## k8s

+ 管理多语言微服务系统，您需要一个通用的微服务和容器编排平台，而 Kubernetes 在这方面出类拔萃
> [在 Kubernetes 集群上构建和部署 Java Spring Boot
> 微服务](https://developer.ibm.com/cn/patterns/deploy-spring-boot-microservices-on-kubernetes/)
> ![Text](https://developer.ibm.com/cn/wp-content/uploads/sites/114/2018/02/Deploy-Spring-Boot-microservices-on-Kubernetes.png)
> + 以 Python 编写的交易生成器服务将模拟交易，并将其推送至计算利息微服务。
> + 计算利息微服务会计算利息，然后将所得币值的分币移至 MySQL 数据库中进行存储。此数据库可在相同部署中的容器内运行，也可在公共云（例如，IBM Cloud）上运行。
> + 随后，在金额已存入用户账户的情况下，计算利息微服务会调用通知服务来通知该用户。
> + 通知服务使用 OpenWhisk 操作向用户发送电子邮件。您也可以调用 OpenWhisk 函数向 Slack 发送消息。
> + 此外，还可调用 OpenWhisk 函数向 Slack 发送消息。
> + 用户可通过访问 Node.js Web 界面来获取账户余额。


+ 选择Kubernetes作为我们的主要容器管理器和部署平台


+ 假设公司进一步发展，流量和业务都极具增多，会出现两个比较常见的问题

    - 扩容动作依然有些麻烦，可以通过预先准备好的操作系统镜像（包括各种线上运行环境），把新的实例快速准备好，但是依然需要更新发布脚本。当然如果有强大的运维团队，是可以做到几乎自动化的。

    - 大量的资源浪费，因为有很多服务，访问量很小，大量的机器可能CPU使用率不足5％这样的case时有发生（来自腾讯的同事分享说，他们的优化目标是CPU利用率平均30%），造成技术成本巨高不下。

    - 理想的状况下，如果把运维手里的机器，都通过一个入口、统一管理起来，统一掌握集群的资源使用，需要对集群扩容或缩容的情况，只要增加或者回收服务器；需要对某个服务扩容缩容，只要简单的设置一下
      replicas 数量。那该多好。

    > [Spring Cloud + Kubernetes 微服务框架原理和实践](https://zhuanlan.zhihu.com/p/31670782)

+ [SpringCloud Kubernetes](http://www.mydlq.club/article/32/)

> 目标是促进 Spring Cloud 和运行在 Kubernetes 中的 Spring Boot 应用程序的集成
> SpringCloud Kubernetes 提供了 spring-cloud-starter-kubernetes-config 组件来解决在 Kubernetes 环境中使用 ConfigMap 或 Secret 动态配置发现与更新问题，当存在 ConfigMap 中的配置或者存在 Secret 中的密码发生更改时候，在 Kubernetes 中的服务能及时监控到这一变化从而按照配置的配置更新策略进行动态更新或者服务重启。











