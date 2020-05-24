---
title: "Product"
date: 2020-04-30T22:52:38+08:00
draft: true
---

记录pe中产品相关内容
<!--more-->


<!-- vim-markdown-toc GFM -->

* [关联](#关联)
* [role pool 加载](#role-pool-加载)

<!-- vim-markdown-toc -->

## 关联

1. 产品组用userType字段来管理用户
2. 通过PRODUCTGROUPPRODUCT关联表和产品建立关联，即一个产品组具有多个产品
3. 产品表利用PRODUCTTRS和系统的交易关联


## role pool 加载

+ sql

    ```sql
    select a.PRDID, a.TRANSCODE
    from PRODUCTTRS a,
         PRODUCTGROUPPRODUCT b,
         PRODUCTGROUP c
    where a.PRDID = b.PRDID
      and b.PRDGRPID = c.PRDGRPID
      and c.USERTYPE = '2';
    ```

    ```xml
    <resultMap class="java.util.HashMap" id="loadRolePoolResult">
		<result property="_ProductId" column="PRDID" />
		<result property="_TransCode" column="TRANSCODE" />
	</resultMap>
    ```

    /Users/jiiiiiin/Documents/Develop/eclipse-workspace/pcommon/src/config/sql-mapping/common/rolepool.xml

    加载个人用户类型相关的产品和交易集合；

    在pcommon中role.xml：

    ```xml
    <bean id="rolePool" class="com.csii.ibs.JdbcTrsGroupRole" >
		<param name="statement">common.loadRolePool</param>
		<ref name="sqlMap">ibsdbSqlMapExecutor</ref>
	</bean>
    ```
    
    + 在该类中会将产品和其下的所有交易，构建出 `SimpleTrsGroupRole` 权限对象
    + 将交易码作为key产品id作为val放到 `trsCode2ProductIdMapping` 便于之后 `String productId = this.rolePool.getProductIdByTrsCode(trsId);` 通过交易码查询其所属的产品
    

