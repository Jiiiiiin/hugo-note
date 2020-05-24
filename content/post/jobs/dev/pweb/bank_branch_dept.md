---
title: "Bank_branch_dept"
date: 2020-05-03T13:05:10+08:00
draft: true
---

对银行和机构相关表的记录
<!--more-->


<!-- vim-markdown-toc GFM -->

* [PUSERPRODUCTGROUP 银行个人产品组表](#puserproductgroup-银行个人产品组表)

<!-- vim-markdown-toc -->

+ 机构码 "Teller", "86" + DeptId.substring(DeptId.length() - 4)


## PUSERPRODUCTGROUP 银行个人产品组表

![Text](http://qiniu.jiiiiiin.cn/I4aPTp.png)

```sql
create table PUSERPRODUCTGROUP
(
    USERSEQ  NUMBER       not null
        constraint F_REFE115
            references PUSER
        constraint SYS_C0028875
            check ("USERSEQ" IS NOT NULL),
    BANKSEQ  NUMBER       not null
        constraint SYS_C0028876
            check ("BANKSEQ" IS NOT NULL),
    PRDGRPID VARCHAR2(32) not null
        constraint SYS_C0028877
            check ("PRDGRPID" IS NOT NULL),
    constraint PK_PUSERPRODUCTGROUP
        primary key (BANKSEQ, PRDGRPID, USERSEQ),
    constraint F_REFE116
        foreign key (BANKSEQ, PRDGRPID) references BANKPRODUCTGROUP
)
/

create index INDEX_64
    on PUSERPRODUCTGROUP (USERSEQ)
/

create index INDEX_65
    on PUSERPRODUCTGROUP (PRDGRPID, BANKSEQ)
/

```

    + 注册个人手机银行的时候，插入银行产品组中定义的数据：

        `select a.BankSeq,a.PrdGrpId from BankProductGroup a,Bank b,ProductGroup c where a.BankSeq=b.BankSeq and b.BankId=#BankId# and c.PrdGrpId=a.PrdGrpId and c.UserType='2'`

        产品组id和银行seq查询出来，再关联上用户seq，批量插入到该表中；



