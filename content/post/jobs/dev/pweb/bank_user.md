---
title: "Bank_user"
date: 2020-05-02T14:26:43+08:00
draft: true
---

用户相关记录
<!--more-->


<!-- vim-markdown-toc GFM -->

* [判断是否开通过网银](#判断是否开通过网银)
* [查询是否开通手机银行](#查询是否开通手机银行)
* [PCIF 个人信息表](#pcif-个人信息表)
* [银行个人信息表 PBANKCIF](#银行个人信息表-pbankcif)
* [PUSER 个人用户表](#puser-个人用户表)
* [个人用户扩展表 puserextend](#个人用户扩展表-puserextend)
* [PACCOUNT 个人账号表](#paccount-个人账号表)
* [个人用户账户对应表 PUSERACCOUNT](#个人用户账户对应表-puseraccount)

<!-- vim-markdown-toc -->

## 判断是否开通过网银

```sql
SELECT b.CifSeq,
       b.CifNo
from PCif a,
     PBankCif b,
     Bank c
where c.BankId =#BankId#
  and b.BankSeq= c.BankSeq
  and a.IdType=#IdType#
  and a.IdNo=#IdNo#
  and a.CifSeq=b.CifSeq
  and b.CifState='0'
  and c.BankState='0';
```

`PBankCif ` 表中维护网银客户状态（0 启用、1 注销），如果一个客户状态为0标示该客户已经开通网银；

## 查询是否开通手机银行

```sql
select u.MobileEbankState, u.userState,
		u.MOBILEDEVICEBINDSTATE,
		u.MOBILEDEVICEBINDMAXNUMBER from puser u
		where u.CIFSEQ = #CifSeq#
		and u.UserId not like '@%'
```
+ MobileEbankState 标示用户开通手机银行状态：0：开通 1:未开通 2：已关闭 5：睡眠户


## PCIF 个人信息表

```sql
CREATE TABLE PCIF(
    CIFSEQ NUMBER(0) NOT NULL,
    CIFNAME VARCHAR2(64),
    CIFSTATE CHAR(1),
    IDTYPE VARCHAR2(2),
    IDNO VARCHAR2(32),
    ADDR VARCHAR2(128),
    PHONE VARCHAR2(32),
    ZIPCODE CHAR(6),
    EMAIL VARCHAR2(32),
    MOBILEPHONE VARCHAR2(16),
    SEX CHAR(1),
    GATHERSTATE VARCHAR2(1),
    MOBILEPHONECHECKSTATE CHAR(1),
    PRIMARY KEY (CIFSEQ)
);;

COMMENT ON TABLE PCIF IS '存储客户基本信息，判断网银是否开通使用的是PBANKCIF中的CIFSTATE';;
COMMENT ON COLUMN PCIF.CIFNAME IS '客户名（真实姓名）';;
COMMENT ON COLUMN PCIF.CIFSTATE IS '0 开户、1销户';;
COMMENT ON COLUMN PCIF.IDTYPE IS '证件类型';;
COMMENT ON COLUMN PCIF.IDNO IS '证件号';;
COMMENT ON COLUMN PCIF.MOBILEPHONE IS '网银注册手机号 1.注册时检查，如果超过配置，报“注册手机号码大于银行规定手机号码数”';;
COMMENT ON COLUMN PCIF.GATHERSTATE IS '资金归集开关';;
COMMENT ON COLUMN PCIF.MOBILEPHONECHECKSTATE IS '手机号检查标志';;
```

![Text](http://qiniu.jiiiiiin.cn/Pr6oly.png)

+ 在用户首次开通个人手机银行的时候插入数据
+ 维护客户状态

    ```java
    public static final String CIFSTATE_0="0"; //开户
    public static final String CIFSTATE_1="1"; //销户
    ```
+ 维护客户基本信息（手机号/姓名...)等基本信息 

## 银行个人信息表 PBANKCIF

```sql
CREATE TABLE PBANKCIF(
    BANKSEQ NUMBER(0) NOT NULL,
    CIFSEQ NUMBER(0) NOT NULL,
    DEPTSEQ NUMBER(0),
    BRANCHSEQ NUMBER(0),
    CIFNO VARCHAR2(32),
    CIFSTATE CHAR(1),
    OPENDATE DATE,
    CLOSEDATE DATE,
    OPENTELLERSEQ NUMBER(0),
    PRIMARY KEY (BANKSEQ,CIFSEQ)
);;

COMMENT ON TABLE PBANKCIF IS '维护网银客户状态（0 启用、1 注销），如果一个客户状态为0标示该客户已经开通网银；2.维护客户开通网银的签约机构';;
COMMENT ON COLUMN PBANKCIF.CIFSEQ IS '客户序号';;
COMMENT ON COLUMN PBANKCIF.DEPTSEQ IS '网点序号';;
COMMENT ON COLUMN PBANKCIF.BRANCHSEQ IS '联社序号';;
COMMENT ON COLUMN PBANKCIF.CIFNO IS '客户号';;
COMMENT ON COLUMN PBANKCIF.CIFSTATE IS '客户状态 0 启用、1 注销';;
COMMENT ON COLUMN PBANKCIF.OPENTELLERSEQ IS '开户操作员序号';;
```

![Text](http://qiniu.jiiiiiin.cn/iU5VI0.png)

银行和客户表的关联表

+ 维护网银客户状态（0 启用、1 注销），如果一个客户状态为0标示该客户已经开通网银；
+ 维护客户开通网银的签约机构

    ```xml
    <isNotEmpty prepend="," property="DeptId">(select DeptSeq from BankDept where DeptId=#DeptId#)</isNotEmpty>
    <isNotEmpty prepend="," property="DeptId">(select BranchSeq from BankDept where DeptId=#DeptId#)</isNotEmpty>
    ```
+ `openDate` 记录开户日期

## PUSER 个人用户表

```sql
CREATE TABLE PUSER(
    USERSEQ NUMBER(0) NOT NULL,
    CIFSEQ NUMBER(0) NOT NULL,
    USERID VARCHAR2(64) NOT NULL,
    PASSWORD VARCHAR2(64),
    USERSTATE CHAR(1) NOT NULL,
    OPENDATE DATE,
    CLOSEDATE DATE,
    OPENTELLERSEQ NUMBER(0),
    CUSTOMLABEL VARCHAR2(64),
    CUSTOMLOGO VARCHAR2(64),
    EBANKTRSPASSWORD VARCHAR2(64),
    MOBILEEBANKSTATE CHAR(1),
    WAPPASSWORD VARCHAR2(64),
    EBANKFAILLOGIN NUMBER(0),
    EBANKFAILLOGINDATE DATE,
    WAPFAILLOGIN NUMBER(0),
    WAPFAILLOGINDATE DATE,
    FIRSTLOGINSTATE CHAR(2),
    SKIN CHAR(1) NOT NULL,
    OTPFAILAUTH NUMBER(0),
    MOBILEEBANKOPENDATE DATE,
    MOBILEEBANKCLOSEDATE DATE,
    EBANKLOGINSUCCOUNT NUMBER(0),
    EBANKLASTLOGINDATE DATE,
    MOBILELOGINSUCCOUNT NUMBER(0),
    MOBILELASTLOGINDATE DATE,
    MOBILEDEVICEBINDSTATE VARCHAR2(1),
    MOBILEDEVICEBINDMAXNUMBER NUMBER(0),
    PRIMARY KEY (USERSEQ)
);;

COMMENT ON TABLE PUSER IS '个人用户表';;
COMMENT ON COLUMN PUSER.CIFSEQ IS '客户序号';;
COMMENT ON COLUMN PUSER.USERID IS '网银/手机银行登陆id 如果以@开头标示用户已经 TODO';;
COMMENT ON COLUMN PUSER.PASSWORD IS '网银密码';;
COMMENT ON COLUMN PUSER.USERSTATE IS '网银状态 0 启用、1 注销  1：销户 2：锁定 9：待激活 5：睡眠户';;
COMMENT ON COLUMN PUSER.OPENDATE IS '开通日期';;
COMMENT ON COLUMN PUSER.OPENTELLERSEQ IS '开通操作员序号';;
COMMENT ON COLUMN PUSER.CUSTOMLABEL IS '客户标签';;
COMMENT ON COLUMN PUSER.CUSTOMLOGO IS '客户标识';;
COMMENT ON COLUMN PUSER.EBANKTRSPASSWORD IS '网银交易密码';;
COMMENT ON COLUMN PUSER.MOBILEEBANKSTATE IS '手机网银（开通）状态 0：开通 1:未开通 2：已关闭（需要到网银/柜面重新开通） 5：睡眠户（状态异常，需要到柜面激活）';;
COMMENT ON COLUMN PUSER.WAPPASSWORD IS '手机银行密码';;
COMMENT ON COLUMN PUSER.EBANKFAILLOGIN IS '网银登录失败次数';;
COMMENT ON COLUMN PUSER.EBANKFAILLOGINDATE IS '登录失败日期';;
COMMENT ON COLUMN PUSER.WAPFAILLOGIN IS '手机网银登录失败次数';;
COMMENT ON COLUMN PUSER.WAPFAILLOGINDATE IS '手机网银登录失败日期';;
COMMENT ON COLUMN PUSER.FIRSTLOGINSTATE IS '第一次登录状态 	00：两者都正常，99：两者都首次登陆，09：手机首次登陆，90：网银首次登陆';;
COMMENT ON COLUMN PUSER.SKIN IS '换肤功能标识肤色';;
COMMENT ON COLUMN PUSER.MOBILEEBANKOPENDATE IS '手机银行-开通时间';;
COMMENT ON COLUMN PUSER.MOBILEEBANKCLOSEDATE IS '手机银行-关闭时间';;
COMMENT ON COLUMN PUSER.EBANKLOGINSUCCOUNT IS '网银当日登录成功次数 查看网银登录操作';;
COMMENT ON COLUMN PUSER.EBANKLASTLOGINDATE IS '网银上次登录时间';;
COMMENT ON COLUMN PUSER.MOBILELOGINSUCCOUNT IS '手机银行当日登录成功次数';;
COMMENT ON COLUMN PUSER.MOBILELASTLOGINDATE IS '手机银行上次登录时间';;
COMMENT ON COLUMN PUSER.MOBILEDEVICEBINDSTATE IS '移动设备绑定状态 0:关闭,1:开启';;
COMMENT ON COLUMN PUSER.MOBILEDEVICEBINDMAXNUMBER IS '移动设备绑定最大数量';;
```

![Text](http://qiniu.jiiiiiin.cn/ll7Phj.png)

+ 个人手机银行注册时插入信息
+ 关联客户表 CifSeq
+ 登记个人手机银行密码 WapPassword/ 开通时机/ 状态/ 首次登陆状态





## 个人用户扩展表 puserextend

+ 记录个人客户的一些扩展信息（RefereePhone 推荐人手机号/Authentication
  添加用户扩展信息-推荐人手机号,是否实名认证:0是，1否/Regmsg
  获取注册渠道和客户端版本）


## PACCOUNT 个人账号表

```sql
CREATE TABLE PACCOUNT(
    ACSEQ NUMBER(0) NOT NULL,
    BANKSEQ NUMBER(0),
    CIFSEQ NUMBER(0),
    ACNO VARCHAR2(32) NOT NULL,
    BANKACTYPE VARCHAR2(2) NOT NULL,
    ACORDER NUMBER(0) NOT NULL,
    ACNAME VARCHAR2(128),
    CURRENCY VARCHAR2(3),
    CRFLAG CHAR(1),
    ACPERMIT CHAR(1),
    OPENDATE DATE NOT NULL,
    CLOSEDATE DATE,
    DEPTSEQ NUMBER(0),
    ACSTATE CHAR(1) NOT NULL,
    ACALIAS VARCHAR2(32),
    PAYMENTFLAG CHAR(1),
    MOBILEACPERMIT CHAR(1),
    DEFAULTSHOWFLAG VARCHAR2(2),
    DEFAULTFLAG CHAR(1),
    BANKACLEVEL VARCHAR2(4),
    PRIMARY KEY (ACSEQ)
);;

COMMENT ON COLUMN PACCOUNT.ACPERMIT IS '账号权限1打开';;
COMMENT ON COLUMN PACCOUNT.ACSTATE IS '账户状态 0:正常 1:销户 10:作废核销 11:密码挂失 12:睡眠户 13:密码锁定 14:质押 15:存款证明 16:其他 2:挂失结清 3:冻结 4:挂失 5:止付 6:关闭 7:临时挂失 8:正式挂失 9:冲正核';;
COMMENT ON COLUMN PACCOUNT.ACALIAS IS '账户别名';;
COMMENT ON COLUMN PACCOUNT.MOBILEACPERMIT IS '转账权限1打开';;
COMMENT ON COLUMN PACCOUNT.DEFAULTFLAG IS '是否是默认帐号，0 是';;
```

+ 在个人手机银行注册的时候通过注册时候查询（从核心和银数）的账户信息插入数据

    ![Text](http://qiniu.jiiiiiin.cn/KGuxgI.png)

## 个人用户账户对应表 PUSERACCOUNT

```sql
CREATE TABLE PUSERACCOUNT(
    ACSEQ NUMBER(0) NOT NULL,
    USERSEQ NUMBER(0) NOT NULL,
    PRIMARY KEY (ACSEQ,USERSEQ)
);;

COMMENT ON TABLE PUSERACCOUNT IS '个人用户账户对应表';;
COMMENT ON COLUMN PUSERACCOUNT.ACSEQ IS '账户序号';;
COMMENT ON COLUMN PUSERACCOUNT.USERSEQ IS '用户序号';;
```

+ 插入数据，个人手机银行的时机同 `PACCOUNT 个人账号表`
+ 一张关联用户和账户的表







