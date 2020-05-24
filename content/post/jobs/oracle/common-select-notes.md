---
title: "Common Select Notes"
date: 2020-04-19T15:40:46+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [常用指令](#常用指令)
* [注意](#注意)
* [概念](#概念)
    * [伪表](#伪表)
    * [伪列](#伪列)
* [函数](#函数)
    * [转换函数](#转换函数)
        * [to_chart](#to_chart)
    * [通用函数](#通用函数)
        * [cast 强制转换数据类型](#cast-强制转换数据类型)
        * [nvl](#nvl)
        * [decode](#decode)
        * [日期函数](#日期函数)
* [表达式](#表达式)
    * [case](#case)
* [查询](#查询)
    * [连接查询](#连接查询)
        * [内链接](#内链接)
        * [外连接](#外连接)
        * [完全连接](#完全连接)
    * [子查询](#子查询)
    * [联合查询](#联合查询)
        * [union 求并集](#union-求并集)
        * [求交集一intersect运算](#求交集一intersect运算)
        * [求差集一minus 运算](#求差集一minus-运算)
    * [区间查询](#区间查询)
    * [like查询](#like查询)
    * [分组](#分组)
        * [过滤分组 having](#过滤分组-having)
* [更新数据](#更新数据)
* [排序](#排序)
* [关联关系](#关联关系)
    * [自关联](#自关联)
* [表](#表)
    * [主键](#主键)
    * [索引](#索引)
        * [主键和索引](#主键和索引)
    * [外键](#外键)
    * [唯一性约束](#唯一性约束)
    * [检查约束](#检查约束)
    * [默认值约束](#默认值约束)
    * [非空约束](#非空约束)
    * [修改表结构 alter table](#修改表结构-alter-table)
    * [删除表](#删除表)
* [数据类型](#数据类型)
    * [固定长度字符串一 char（n）](#固定长度字符串一-charn)
    * [varchar（n）](#varcharn)
    * [varchar2（n）](#varchar2n)
        * [varchar2（n）与char（n）的区别](#varchar2n与charn的区别)
    * [数值类型](#数值类型)
* [视图](#视图)
    * [视图（内嵌/关系）和历史表选择](#视图内嵌关系和历史表选择)
* [游标](#游标)
* [序列](#序列)
    * [自动生成序号](#自动生成序号)
* [表空间相关](#表空间相关)
    * [查询表空间](#查询表空间)
* [用户权限相关](#用户权限相关)
    * [用户](#用户)
        * [修改用户密码](#修改用户密码)
    * [权限](#权限)
        * [系统权限](#系统权限)
        * [对象权限](#对象权限)
    * [角色](#角色)
        * [创建自定义“数据库”](#创建自定义数据库)
* [索引](#索引-1)

<!-- vim-markdown-toc -->

## 常用指令

```sql

-- sqlplus登陆

sqlplus username/password [netservicename]

-- 连接到某个用户
connect scott/tiger;

-- 关闭/重启数据库

-- 1.以DBA身份登陆数据库
sqlplus /@USERNAME as sysdba;

-- TODO
sqlplus / as sysdba

-- 2.关闭数据库
-- 关闭数据库，应该使用shutdown命令，其后紧跟关闭选项，一般使用 immediate一立即关闭数据库。数据库关闭的过程为：数据库关闭一数 据库卸载一 一实例卸载。
shutdown immediate;

-- 3 重启数据库，利用startup命令可以重启数据库;
-- 启动数据库的过程中，如果出现异常，Oracle 将会给出错误信息。例如，ORA一32004：obsolete and/or deprecated parameter（s） specified就是由于数据库启动参数设置不当引起的。
startup;

-- 查看数据库参数

-- 要求显示参数
-- show parameter parameter_name;


-- 查看实例名

show parameter instance_name;

-- 模糊查询，即我们可以只输入部分参数名称，oracle将会返回所有能模糊匹配的参数设置
show parameter instance;

-- 修改系统参数
-- 如查看和修改闪存
show parameter recovery;

-- 其中，alter system用于修改系统环境； set db_recovery_file_dest_size=5g将参数db_recovery_file_dest size 的值设置为5G； scope =both，代表将参数修改应用于当前环境和数据库启动参数中。
alter system set db_recovery_file_dest_size=5g scope=both;

-- 查看当前oracle版本信息
select * from v$version;

-- 查看当前用户　　
show user 
select user from dual;

-- 查看某个用户的状态

select username, account_status from dba_users where username='SYSTEM';

-- 解锁用户，以system用户为例
-- 其中，alter user命令用于修改用户属性； system为要修改的用户； account为用户账号：unlock指定账号的最新状态为解锁。
alert user system account unlock;

-- 重置用户密码，其中，alter user system identifed by abc123用于修改system账户的密码为abc123。这里需要注意的是，Oracle 的用户名不区分大小写，但密码是区分大小写的。
alter user system identified by 新密码;


-- 查看当前用户下的表
select * from tab where tabtype='TABLE'　 

-- 通过表名查询对应的所属表空间
-- 通过视图 `user_tables` 查看当前用户所拥有的表信息，如查看`EMP`表的表空间信息

select table_name, tablespace_name from user_tables where table_name='EMP';


-- 通过列名查询表名
-- 当前Schema （用户）所有列的信息。对应于Oracle中，可以通过视图user_ _tab_ cols获得当前用户的所有列的信息。很多时候往往需要从列追溯表信息。例如，在知道列名的情况下，试图找到该列出现在哪些表中。
select table_name from user_tab_cols where column_name='EMPNO';


-- 使用sqlplus自带命令describe来查看表结构

desc TABEL_NAME;


```



## 注意

+ sql语句本身不区分大小写，但是查询条件中的值是区分的；
+ 笛卡尔积

    ![Text](http://qiniu.jiiiiiin.cn/eQZ3nG.png)

    得到的记录，是对应表记录的乘集

    - > [程序员与笛卡尔积](https://juejin.im/post/5c1c5301e51d451cdc394d13)
    
    - 笛卡尔积获得的是两个数据表的乘积 

    - 针对以上的理论，我们提出一个问题，难道表连接的时候都要先形成一张笛卡尔积表吗？
如果两张表的数据量都比较大的话，那样就会占用很大的内存空间这显然是不合理的。所以，我们在进行表连接查询的时候一般都会使用JOIN xxx ON xxx的语法，ON语句的执行是在JOIN语句之前的，也就是说两张表数据行之间进行匹配的时候，会先判断数据行是否符合ON语句后面的条件，再决定是否JOIN。

    - 消除笛卡尔积

    - 因此，有一个显而易见的SQL优化的方案是，当两张表的数据量比较大，又需要连接查询时，应该使用 FROM table1 JOIN table2 ON xxx的语法，避免使用 FROM table1,table2 WHERE xxx 的语法，因为后者会在内存中先生成一张数据量比较大的笛卡尔积表，增加了内存的开销。

    - 添加关联表的关联字段来进行消除：`select * from EMP e, DEPT d where e.DEPTNO = d.DEPTNO;`

    - 即必须要使用关联字段来进行关联筛选；


## 概念

### 伪表

+ dual表，在介绍了Oracle中数据库、表空间、表的基本操作之后。本节将介绍Oracle中非常特殊的数据表一dual.
  dual 表实际属于系统用户 sys，具有了数据库基本权限的用户，均可查询该表的内容。

+ 在这里有一个问题就会出现，在 Oracle 里面所有的验证操作必须存在在完整的 SQL 语句之中，分析查询结果可知，dual 表仅含有一行一列。该表并非为了存储数据而创建的，其存在的意义在于提供强制的数据源。
在Oracle中，所有查询语句必须满足select column name from table_ name的格式。但是，某些场景下，数据源table. _name 并不明确。例如，函数sysdate（）用于返回当前日期，那么在SQL命令行下调用该函数时，很难有明确的数据源，此时即可使用dual表，如示例3一12所示。
+ 方便在做一些不基于实体表来查询输出的操作，如 `select upper('Oracle') from dual;`

### 伪列
+ 取得当前的系统时间，可以直接利用 SYSDATE
  伪列取得当前日期时间。所谓伪列指的是不是表中的列，但是有可以直接使用的列。`SELECT empno,ename,SYSDATE FROM emp;`

## 函数

+ [Oracle数据库之单行函数详解](https://www.linuxidc.com/Linux/2019-09/160466.htm)


### 转换函数

在数据库之中主要使用的数据类型：字符、数字、日期（时间戳），那么这三种数据类型之间就需要实现转换操作，这就属于转换函数的功能。

#### to_chart

TO_CHAR(日期|数字|列, 转换格式)	将指定的数据按照指定的格式变为字符串型

+ 金额格式化 `select ENAME, to_char(SAL, '99,999') from EMP;`

    ![Text](http://qiniu.jiiiiiin.cn/m3uY61.png)

### 通用函数

这些函数是 Oracle 数据库的特色，对于这些函数了解有一定的好处。

#### cast 强制转换数据类型

Oracle中的cast（）函数可以强制转换列或变量的数据类型。其使用语法如下所示。

`cast(原数据 as 新的数据类型)`

+ 一个典型应用场景为利用一个已有表创建一个新表。在创建过程中，使用cast（）函数将列的数据类型进行转换


#### nvl

+ NVL(数字|列 , 默认值)	如果显示的数字是null的话，则使用默认数值表示

+ 如获取员工的年薪*（加上奖金）： `select ENAME, SAL*12+nvl(COMM, 0) from EMP;`

#### decode

DECODE() 函数是 Oracle 中最有特色的一个函数，DECODE() 函数类似于程序中的 if...else if...else ，但是判断的内容都是一个具体的值，语法如下：

DECODE(列|表达式, 值1, 输出结果, 值2, 输出结果, ..., 默认值)

+ 但是需要注意的是，如果使用 DECODE() 函数判断，那么所有的内容都要判断，如果只判断部分内容，其它内容就会显示 null
+ 现在雇员表中的工作有以下几种：CLERK:业务员, SALESMAN:销售人员, MANAGER:经理, ANALYST:分析员, PRESIDENT:总裁 ，要求查询雇员的姓名、职位、基本工资等信息，但是要求将所有的职位信息都替换为中文显示。

```sql
SELECT ename,sal,
DECODE(job,
    'CLERK','业务员',
    'SALESMAN','销售人员',
    'MANAGER','经理',
    'ANALYST','分析员',
    'PRESIDENT','总裁') job
FROM emp;
```





#### 日期函数

+ 当前日期

除了取得系统时间的操作之外，在 Oracle 中也有如下的三个日期操作公式：
日期 - 数字 = 日期， 表示若干天前的日期
日期 + 数字 = 日期， 表示若干天后的日期
日期 - 日期 = 数字（天数），表示两个日期的天数的间隔
可是绝对不会存在 “日期 + 日期” 的计算，下面为其验证。

SELECT
    SYSDATE+3 三天之后的日期,
    SYSDATE-3 三天之前的日期
FROM dual;

+ MONTHS_BETWEEN() 函数的功能是取得两个日期时间的月份间隔

+ 日期格式化成字符串：`select to_char(sysdate, 'yyyy-mm-dd HH:mi:ss') from DUAL;` `select to_char(sysdate, 'yyyy-mm-dd HH24:mi:ss') from DUAL;`

    这里使用的是转换函数来完成，TO_CHAR(日期|数字|列, 转换格式)
    将指定的数据按照指定的格式变为字符串型

+ 格式化成时间：`select to_date('1986-08-05', 'yyyy-mm-dd') from DUAL;`

+ 去除前导零 `select ename, to_char(HIREDATE, 'fmyyyy-mm-dd') from EMP;`

## 表达式

### case

CASE 表达式是在 Oracle 9i 引入的，功能与DECODE() 有些类似，都是执行多条件判断。不过严格来讲，CASE表达式本身并不属于一种函数的范畴，它的主要功能是针对于给定的列或者字段进行依次判断，在 WHERE 中编写判断语句，而在 THEN 中编写处理语句，最后如果都不满足则使用 ELSE 进行处理。

![Text](http://qiniu.jiiiiiin.cn/pG22mH.png)


+ 显示每个雇员的工资、姓名、职位，同时显示新的工资（新的工资标准：办事员增长10%，销售人员增长20%，经理增长30%，其他职位的人增长50%）

    ```sql
    SELECT ename,sal,
    CASE job WHEN 'CLERK' THEN sal * 1.1
        WHEN 'SALESMAN' THEN sal * 1.2
        WHEN 'MANAGER' THEN sal * 1.3
    ELSE sal * 1.5
    END 新工资
    FROM emp;
    ```
    



## 查询

### 连接查询

> [oracle连接查询详解](https://blog.csdn.net/IndexMan/article/details/7768811)


> [理解数据库的内连接、外连接和交叉连接]((https://juejin.im/entry/5abf9292518825556e5e394a)


#### 内链接

> [Oracle INNER JOIN语法简介](https://www.yiibai.com/oracle/oracle-inner-join.html)

   An inner join (sometimes called a simple join) is a join of two or more tables that returns only those rows that satisfy the join condition.

   内连接也叫简单连接，是2个或更多表的关联并且仅返回那些满足连接条件的行。

+ 内连接运算innerjoin中的inner关键字可以省略
+ 默认情况下，Oracle的连接为内连接，因此，在这里，使用了join代替inner join可以实现相同的效果，而且写法更为简洁。
+ 对比使用where条件来实现的方式（对于大多数开发者来说，并不习惯使用内连接方式，而更习惯于where条件来现。利用where条件改写本示例的SQL语句如下所示。）

    ```sql

    select * from TABLE1 join TABLE2 on join_predicate;

    --- 对比

    select * from TABLE1, TABLE2 where condition;
    
    ```

    虽然可以利用where子句改写内连接的SQL查询，但需要注意的是，当实现多表关联，Oracle在执行时还是有区别的。对于where子句方式，并且from子句中含有多个数据源，Oracle在进行笛卡尔积运算时会自行优化。例如，对于SQL语句.
    

#### 外连接

内连接所指定的两个数据源，处于平等的地位。而外连接不同，外连接总是以一个数据源为基础，将另外一个数据源与之进行条件匹配。即使条件不匹配，基础数据源中的数据总是出现在结果集中。那么，依据哪个数据源作为基础数据源，便出现了两种外连接的方式一左 （外）连接和右（外）连接。因为内连接没有左右之分，所以习惯上，将左外连接和右外连接简称为左连接和右连接。


#### 完全连接

完全连接实际是一个左连接和右连接的组合。也就是说，如果两个数据源使用了完全连接，那么将首先进行一次左连接，然后进行一次右连接，最后再删除其中的重复记录，即得到完全连接。完全连接应该使用full join关键字，并使用on关键字指定连接条件。

完全连接的执行过程为：首先执行表employees与salary的左连接，然后执行G者的右连接，最后将两个临时结果集进行union操作。


### 子查询

子查询是指在查询语句的内部嵌入查询，以获得临时的结果集。Oracle总是自动优化带有子查询的查询语句。如果子查询中的数据源与父查询中的数据可以实现连接操作，那么将转化为连接操作；否则，将首先执行子查询，然后执行父查询。

+ 建表语句中的子查询

    ```sql
    create table TABLE_NAME as select * from ORIGIN_TABLE_NAME where 1<>1;
    ```

    `as`后面的子查询获得一个空结果集；利用该结果集创建数据表时，将创建一个空数据表；

+ 插入语句中的子查询

    同样，我们也可以在插入语句中使用子查询。这相当于向表中批量插入数据。

    ```sql
    insert into TABLE_NAME select * from ORIGIN_DATA_TABLE_NAME where
    FILTER_COLUMN='CONDITION_VALUE';
    ```


### 联合查询

对于这4种集合运算一union 运算、union all运算、intersect运算和minus运算， Oracle允许进行混合运算。在混合运算时，这4种运算的优先级是相同的，也就是说，它们将按照自左至右的顺序依次进行。

#### union 求并集

union运算实际是合并两个结果集中的所有记录，并将其中重复记录剔除（保证结果集中的记录唯一）。

所获得的结果集进行并集运算。

但需要注意的是，union 运算的两个结果集必须具有完全相同的列数，并且各列具有相同的数据类型。

+ union all

    union all 运算与union运算都可看做并集运算。但是union all 只是将两个运算结果集进行简单整合，并不剔除其中的重复数据。这是与union运算的最大区别。

    同时，由于union all 运算不删除重复记录，因此在执行效率.上要高于union操作。因此，当对两个结果集已经确定不会存在重复记录时，应该使用union all操作，以提升效率。

#### 求交集一intersect运算

interset运算是指交集运算。该运算可以获得两个结果集的交集一 一即同时存在于两个结果集中的记录。


#### 求差集一minus 运算

minus 是集合间的减法运算。该运算将返回第一个集 合中存在，而第二个集合中不存在的记录。



### 区间查询

```sql
select * from EMP where SAL between 1500 and 3000;

-- 等价于

select * from EMP where SAL >= 1500 and SAL <= 3000;

-- 查询在两个日期区间内的记录

select * from EMP where HIREDATE between to_date('1981/1/1', 'yyyy/mm/dd') and to_date('1981/12/31', 'yyyy/mm/dd');
```

### like查询

+ `%`可以匹配任意长度
+ `_`只匹配一个长度


### 分组

> [SQL GROUP BY 语句](https://www.w3school.com.cn/sql/sql_groupby.asp)

> “Group By”从字面意义上理解就是根据“By”指定的规则对数据进行分组，所谓的分组就是将一个“数据集”划分成若干个“小区域”，然后针对若干个“小区域”进行数据处理。

+ Group By中Select指定的字段限制

    ```sql
    select 类别, sum(数量) as 数量之和, 摘要
    from A
    group by 类别
    order by 类别 desc
    ```

    示例3执行后会提示下错误，如下图。这就是需要注意的一点，在select指定的字段要么就要包含在Group By语句的后面，作为分组的依据；要么就要被包含在聚合函数中。

#### 过滤分组 having

where子句可以过滤from子句所指定的数据源，但是对于group by子句所产生的分组无效。为了将分组按照一定条件进行过滤，应该使用having子句。




## 更新数据

+ 除了delete 命令，Oracle 还可以利用truncate table命令删除表中的数据。但是truncatetable语句与delete 语句是有本质区别的。delete 语句与insert、update 语句同属于DML一数据操作语言的范畴，当数据修改之后，可以通过回滚操作，忽略所做的数据修改。而truncate table语句则是属于DDL一数据定 义语言的范畴，当数据被删除之后，无法回滚。

+ delete操作与truncate table 操作具有不同的应用场合：当删除部分数据时，应该使用delete语句，并添加where条件；删除全部数据时，应该使用truncatetable语句。同时，truncatetable删除全表数据时，效率也要高于delete语句。

+ 使用`select * from T1 for update where condition`来更新记录是最佳实践

    ![Text](http://qiniu.jiiiiiin.cn/ftqmeB.png)

    ![Text](http://qiniu.jiiiiiin.cn/dwgZRh.png)

    - 删除记录

        ![Text](http://qiniu.jiiiiiin.cn/Jc4hSW.png)

## 排序

+ oracle 默认是按字母的正序排 `asc`
+ 排序建议都放在查询语句的最后

## 关联关系

### 自关联

+ 参考 `EMP`表，其中`MGR`字段就是员工的上级领导的编号（即员工表的`EMPNO`）字段

    ```sql
    -- auto-generated definition
    create table EMP
    (
        EMPNO    NUMBER(4) not null
            constraint PK_EMP
                primary key,
        ENAME    VARCHAR2(10),
        JOB      VARCHAR2(9),
        MGR      NUMBER(4),
        HIREDATE DATE,
        SAL      NUMBER(7, 2),
        COMM     NUMBER(7, 2),
        DEPTNO   NUMBER(2)
            constraint FK_DEPTNO
                references DEPT
    )
    /

    ```

    + 自关联查询 `select e.ENAME, p.ENAME from EMP e, EMP p where e.mgr = p.EMPNO;`
    + oracle自身的层次化查询： `select * from EMP start with ENAME = 'KING' connect by prior EMPNO = MGR;`

    + "得到层次路径"

        `select EMPNO, ENAME, sys_connect_by_path(ENAME, '/') from EMP start with ENAME = 'KING' connect by prior EMPNO = MGR;`

        ![Text](http://qiniu.jiiiiiin.cn/7rEXpQ.png)
        
        对于层次化查询，最常用的函数为sys_ connect _by_ _path（）函数。层次化查询总是以某条记录为起点，根据connect by所指定的条件递归获得结果集合。而sys_ connect. by_ path（）函数，则可以对起始至当前记录之间的结果集进行聚合操作。该操作仅限于串联字符串，相应的语法如下所示。
sys_connect_by_path （列名，分隔符）

        
    + 但是如果子表中的自关联字段为空，那么再去匹配父亲字段，就相当于那空去匹配，所以就不会得到记录，比如EMP中的`KING`这个用户就没有上级


## 表

+ Oracle表空间的下一层逻辑结构为数据表。相较于其他数据库，Oracle 中的数据表并无特别之处。创建和修改数据表结构都使用标准的SQL语句。

+ create table命令用于创建一个 Oracle数据表;括号内列出了数据表应当包含的列及列
的数据类型; tablespace则指定该表的表空间。

+ > [语法](https://wenku.baidu.com/view/c6caebea19e8b8f67c1cb94b.html)

+ 通过视图user_tables 可以获得当前用户所拥有的表信息，利用如下SQL语句可以查看表student的表空间信息。

    ```sql
    select table_name, tablespace_name from user_tables where table_name='EMP';
    ```


### 主键

当在一个表上建立了主键，那么表中所有数据在主键列上的值（或值的组合）不能重复，并且主键列上的值不能为空。

![Text](http://qiniu.jiiiiiin.cn/qVK49w.png)

+ 建表时候创建

    `create table TABLE_NAME (COLUMN_NAME TYPE primary key, ...)`

    可以这样在列的描述之后使用 `primary key`关键字来将该列指定为主键列；

    联合主键：

    ```sql
    create table TABLE_NAME (COL1 TYPE, COL2 TYPE, ..., primary key (COL1,
    COL2));
    ```

    对于单列主键，可以在列的描述中定义主键。但是对于多列主键，则必须将主键描述与列的描述并列进行。

    或者：

    `ALTER TABLE "EBANK"."PRODUCTGROUP" ADD CONSTRAINT "PK_PRODUCTGROUP" PRIMARY KEY ("PRDGRPID");`

    对已经存在（一般是存储了数据）的表重新创建主键：

    `alter table TABLE_NAME add primary key (COLUMN_NAME, ...);`

    其中，alter table命令用于修改表的属性； primary key（列名1，列名2..）则指定主键被建立在哪些列之上，各列名之间使用逗号进行分隔。
    



    - 为主键命名

    对于表的主键来说，由系统自动分配固然省却了开发人员的工作。但是，有时开发人.员也想自行控制主键，那么，显式命名主键便显得特别重要。

    主键是约束的一种，可以利用为表添加约束的方式显式命名约束，从而实现命名主键。其语法形式如下所示。

    `alter table TABLE_NAME add constraint 约束名称 primary key(COL1, ...);`

    其中，alter table侖令用于修改表的属性； add constraint 用于为表添加约束，并指定约束名称： primary key（列名1，列名2..）指定约束的详细定义。

    如：`alter table EMP add constraint pk_emp primary key(EMP_NO);`

    


+ 删除主键

    `alter table TABLE_NAME drop primary key;`

    drop primary key用于删除一个表的主键， 因为主键在一个表中的唯一 一性， 因此，无须.指定主键名称： add primary key（employee id）用 于为表添加主键，该主键建立在列employee_ id上。


+ 查询主键信息

    ![Text](http://qiniu.jiiiiiin.cn/L16Nsj.png)


    ![Text](http://qiniu.jiiiiiin.cn/RlrGg3.png)


+ 修改主键约束

    主键约束作为数据库的对象之一，同样可以对其进行属性修改。修改主键约束主要包括两方面的内容：禁用/启用主键和重命名主键。

    - 禁用/启用主键

    对于一个数据表，有时并不希望某些操作受主键影响，但又不想删除主键。那么，便可以采取临时禁用的策略。当需要主键约束时，再次启用即可。禁用/启用数据表主键的语法如下所示。

    `alter table TABLE_NAME disable primary key;`

    启用：

    `alter table TABLE_NAME enable primary key;`

    注意如果有存在违反约束的情况，启用将不会成功，需要解决冲突数据之后才行；

    - 重命名主键

    `alter table TABLE_NAME rename constraint 原主键名称 to 新主键名称;`

    其中，rename constraint用于重命名约束，主键是约束的一种，因此，该选项同样适用于重命名主键；to关键字则用于指定新的主键名称


### 索引

索引是数据库提供的一种可以用于提高数据性能的机制。当用户在数据表的某列（或某些列）。
上创建了索引，而在检索数据时又使用了该索引列时，Oracle可以很快地捕获符合条件的记录。而不必采用全表逐条扫描的方式。


#### 主键和索引

【示例12一13】在Oracle中，创建了主键之后，都会存在一个建立在主键列上的索引。例如，表employees的主键pk_employees建立在列employee_id上。可以通过视图user_indexes获得表employees上索引的详细信息。

![Text](http://qiniu.jiiiiiin.cn/mKXAmm.png)

可以通过另外一个视图user_ ind_ columns 来查看索引建立在哪些列之上。

![Text](http://qiniu.jiiiiiin.cn/EjsTXp.png)

其中，列index_ name 标识了索引名称；列table_ name 标识了表名；列column_ name标识了索引列。分析查询结果可知，在表employees上有名为SYS_ _C005058的索引，该索引建立在列employee_ id上。

综合以上操作步骤可知，当Oracle创建主键时，会自动创建一一个与主键同名的索引。索引列与主键列相同，但是，当用户重命名主键之后，索引并不会随之重命名。

虽然索引名称不会随着主键的重命名而重命名，但是却会随着主键的删除而被删除。

当Oracle创建主键时，会首先查看主键列上是否已经创建了索引。如果未创建，则自动创建；如果已创建，Oracle 直接创建主键，而不会进行索引创建。已存在的索引也和主键没有任何连带关系，因此，当删除主键时，不会触发索引的任何动作。


### 外键


外键实际是一个引用。一个数据表有自己的主键，而向外部其他数据表的引用，则称作外键。这里需要注意的是，外键实际隐含了对外部引用的限制一必须获得外部数据表的唯一记录。 如同一个身份证只能指向一个户籍，而一一个订单也只能属于一个客户。


主键的作用是保证数据完整性一 一即保证数据的唯一性。这如同现实世界的任意两个人，即使拥有再多的共同点，也会具有不同的身份证号加以区分。因此，主键可以看作表中数据之间的区分。而外键约束则适用于不同表之间的相互参照关系。


- 参照完整性

在两个表之间，一个表中的记录依附于另一个表的记录而存在，称为表之间的参照完整性。参照完整性总是存在着真实的业务背景。例如，在customer表中，存储了每位客户的信息：在purchase_ _order 表中存储了订单信息。Purchase_ order 中的每条记录都依附于customer表中记录的存在而存在，即建立了两个表之间的参照完整性。


- 主键和外键的关系

以客户表与订单表为例，订单表要建立向客户表的引用。那么必须在订单表中保存客户信息列。例如，在图12一1中，订单表中含有客户ID。将外键建立在该列之上，那么通过每一个客户ID都能在客户表中获得唯一记录。为了能获得唯一记录，客户表中的客户ID必须为主键。这也是为什么作为外键支持的列，必须是主键列的原因。

![Text](http://qiniu.jiiiiiin.cn/UqDD9Z.png)

+ 创建外键

    `alter table TABLEL_NAME add constraint 约束名 foreign key(外键列名）references
    主表(主表主键列）;`

    其中，alter table用于修改从表的属性： add constraint用于为表添加约束： foreign key指定约束的具体类型一一外键； references 主表（主表主键列）用于指定外键引用的另一端一主表及主表的主键列。

    如：

    ![Text](http://qiniu.jiiiiiin.cn/YngHBv.png)

+ 查看外键信息

    同样可以在视图user_ constraints 和user_ cons_ columns 中获取外键的详细信息。


+ 集联操作

        在数据更新操作中，无论更新主表customer还是从表purchase_ _order 中的customer_ id为2，都将破坏参照完整性。因此，Oracle 将抛出错误提示，并禁止修改操作

    在12.2.3节中可以看到，尝试修改主表和从表中的数据并不一定能够成功。但是有时又的确有这种需求。对于某个客户，同时修改customer 表与purchase_ order 表中的customer_ id 列的值。另外，当某一客户被删除时，也应该同时删除该客户所拥有的所有订单。主表的操作，将连带影响到从表的操作，这就是级联更新与级联删除问题的提出背景。

    所谓级联更新，是指当主表中的主键列进行修改时，子表的外键列也应该进行相应的修改。级联删除是指当主表中的记录删除时，子表中与之相关的记录也应该同时删除。

    外键约束之所以会限制父表与子表的更新，是因为数据完整性校验无法通过。该校验有两种类型一即 时校验（ immediate）和延迟校验（deferred） 。默认为即时校验，即每执行一条语句，都会进行校验；而延迟校验可以指定校验的时机。

注：外键约束不常用故这里就不继续了

### 唯一性约束

唯一性约束是数据库中另一个重要约束。唯一性约束与主键约束一样，也是建立在一个或多个列之.上，从而实现数据在该列或者列组合上的唯一性。

唯一性约束创建之后，要求在约束列上的值（或值的组合）保持一致。

+ 为何要使用

    对于一个数据关系来说，可以拥有一个主码，同时还可以拥有多个候选码。主键约束是主码的体现。对于一个数据表来说，主键只有一个。但是，主键往往与业务无关，另一方面，在业务逻辑上保持记录唯一性也是不可忽视的。此时，唯一性约束便成为候选码的实现机制，同时也是主键约束的有益补充。

+ 和主键的不同

1.二者的相同点主要包括

（1）唯一性约束和主键都可以限制表中记录的唯一性。
唯一性约束和主键约束分别是候选码和主码的具体实现。因此，二者都可以唯一确定表中记录。

（2）唯一性约束和主键都可以建立在单列或列的组合上。
唯一性约束同样可以建立在单列或列的组合之上。而正是这一特征， 使其更加容易地适应业务逻辑上保持实体的唯一性。

2.二者的不同点主要包括

（1）表中允许的个数不同。

在一个表中，主键是唯一的，最多只能含有一个主键。而表中的唯一性约束却没有数量.上的限制。

（2）唯一性约束的列值允许为空。

对于主键约束，其实隐含了这样一种应用，即通过主键作为条件可以唯一获得一 条记录，因此列值不允许为空；而对于唯一性约束， 只是限制记录的唯一性， 并不含有查询记录的需求，因此，其列值允许为空。

（3）唯一性约束创建时不会连带创建索引。

主键约束在创建时，如果主键列上不含有索引，那么将利用主键列自动创建索引。对于唯一性约束，这种连带动作是不存在的。

+ 创建

    唯一性约束也是约束的一种，因此，可以利用创建约束的一般语法来新建唯一性约束。在创建成功之后，同样可以利用数据字典获取其详细信息。

    `alter table TABLE_NAME add constraint 约束名称 unique(COL1, ...);`

    其中unique表示该约束是一一个唯一性约束；小括号内指定唯一性约束创建在哪些列之上，多列之间使用逗号进行分隔。

    ![Text](http://qiniu.jiiiiiin.cn/LH3Pu3.png)

    另外也可以对其进行删除/重命名/启用禁用操作，也不常用就不记录了;


### 检查约束

检查约束的使用是有必要的。例如，在存储了学生成绩的数据表中，小学生的单科成绩不能超过100分，但也不能少于0分；在存储了合同信息的数据表中，劳动合同的开始日期不能晚于结束日期。这些校验在单条记录的列或列之间进行，不能利用主键、外键等象进行约束。此时，最合适的解决策略为检查约束。

检查约束实质是一一个布尔表达式。一旦在数据表上创建了检查约束，那么该检查约束将在数据更新时计算布尔表达式的值。如果计算结果为真，则表明校验通过，并可成功更新数据；否则，Oracle 将禁止数据的更新操作。
一个检查约束可以用来限制某列的取值范围，还可以用来限制多列之间的关系。而检查约束所定义的布尔表达式也可以是多个布尔表达式进行逻辑运算的结果。因此，检查约束可以实现非常强大和灵活的限制策略。
理论上，一个数据表可以含有多个检查约束。但多检查约束的策略并不常用，因为多个检查约束的条件总是可以利用“与”操作合并到单个检查约束的定义中。

+ 创建

    创建检查约束与其他约束的语法基本相同。只是将约束的具体类型定义为check， 如下所示。

    `alter table TABLE_NAME add constraint 约束名称 check(布尔表达式);`

    例如：

    `ALTER TABLE "EBANK"."PRODUCTGROUP" ADD CONSTRAINT "SYS_C0028790" CHECK ("PRDGRPID" IS NOT NULL) NOT DEFERRABLE INITIALLY IMMEDIATE NORELY VALIDATE;`


    > [oracle Deferrable constraint 详解以及用法.](https://blog.csdn.net/nvd11/article/details/12654691)
    

在实际工作中，一般都在应用层处理字段的有效性，故这里不做记录了；

### 默认值约束

即为某一个字段设置默认值，在无数据插入时候使用默认值进行填充；

可以将默认值约束的概念统一起来一当 没有设定默认值约束时，可以将列的默认值看做空，即null；当显式设定默认值时，列的默认值发生改变。因此，可以认为列的默认值总是存在的。
值得注意的是，对于Oracle

9i以前的版本，用户设置默认值时，只能使用常量值；而.Oracle9i及以后版本，用户将可以使用sysdate等函数设定列的默认值。

+ 创建默认值

    创建默认值约束的语法不同于其他约束，获得相关信息也应该使用不同的数据字典。

    与创建其他约束不同，默认值约束并非针对记录的约束条件，而是作为列的属性存在。因此，创建默认值约束实际是通过修改列属性的途径来实现的。

    创建默认值约束应该使用modify选项，并指定约束类型为default （默认值） 。

    `alter table TABLE_NAME modify COLUMN_NAME default 'DEF_VAL';`

    `alter table contract modify status default 'ACT'`

    其中，alter table contract 用于修改表contract的结构： modify status 用于修改列status的属性： default 'ACT'则用于指定列的默认值为‘ ACT” 。

    这样在插入记录时候没有指定对应字段的值的时候，该字段将会被自动填充；

+ 查看默认值约束的信息

    与前面所讲述的主键、外键、唯一性及检查约束不同。默认值约束并非作为表的属性，而是作为列的属性而存在的。因此，无法在数据字典user_ constraints 中获得其信息。因为user_ constraints 中的约束都是针对表而言的。

    数据字典user_ tab_ columns 包含了所有用户列的信息。我们可以利用如下SQL语句获得列status的详细信息。

    `select * from user_tab_columns where table_name='表名' and
    column_name='字段名'`

    其中，table_ name 标识了表名； column_ name 标识了列名； data _type 标识了列的数据类型； data_ default 标识了列的默认值。分析查询结果可知，表contract 的列status 的默认值为“ACT” 。

    从Oracle9i开始，除了利用常量（如“ACT" ）设置默认值约束之外，还可以利用函数的返回值设置默认值约束。

    `alter table TABLE_NAME modify COLUMN_NAME default(sysdate);`

+ 修改默认值约束

    默认值约束的主要操作为删除默认值约束。而其删除的方式也与其他约束不同。当某个列没有默认值时，可以认为其默认值为null。 因此，删除默认值约束的方式即为将其设置为null。

    `alter table TABLE_NAME modify(COLUME default null, ...);`

### 非空约束


与默认值约束一样，非空约束同样是针对表的列所进行的约束。非空约束用于限制列值不能为空。这将强制用户必须输入有效数据，进而保证数据完整性。

+ 为什 么要使用非空约束

        默认情况下，数据表的列值允许为空。这将允许用户在插入数据时，可以忽略列值。但是，有时候，并不允许用户忽略列值。例如，对于存储了借贷信息的数据表，借款人一项不能为空；否则，将导致严重的数据完整性问题。

    1.非空约束与检查约束

    检查约束可以限制数据表中的某列的取值范围。当这个取值范围被限定为非空（is notnull）时，要求列值不能为空。

    非空约束总是针对数据表的列。一旦为某列添加了非空约束，那么，要求该列的列值不能为空（isnotnull）。这相当于在列上添加了一个检查约束，这个特殊的检查约束条件是，列值不能为空。当然，这里是指非空约束与某个特殊的检查约束有相同的效果，二者仍然是两种不同的约束。

    2.非空约束与主键

    主键值不能为空。Oracle为了保证这一特点，在创建主键约束的同时，为主键列添加非空约束。非空约束与主键索引一样，都会作为主键生成时的附属产物而生成。


+ 创建

    与默认值约束相同，非空约束也是作为列的属性，而非表的属性存在的。因此，创建非空约束，也应该使用修改列属性的方式进行。当然，创建非空约束之后，同样可以在数据字典中获取其相关信息。.

    `alter table 表名 modify(列名 not null);`

    可以使用desc指令查看对应列的非空约束，其中，nullable
    表明当前列是否可以为空。默认情况下，其值均为“Y 、即可以为空；

    另外也可以在数据字典`user_tab_columns`中查看相关信息：`select * from user_tab_columns where table_nam='表名'`

    其中，列table_ name 标识了表名；列column_ name 标识了列名；列data_ _type 标识了列的数据类型；列nullable标识了列是否允许为空


    值得注意的是，为列指定默认值约束，可以解决非空约束必须输入的限制。

+ 修改

    非空约束的主要操作是删除动作。非空约束的删除与默认值约束的删除有相似之处，都是通过修改列的属性来实现的。删除列的非空约束，只需将列的属性指定为null即可。

    `alter table 表名 modify(字段名 null);`

    其中，字段名 null 用于重新定义列的属性，null 表示允许列值为空。


### 修改表结构 alter table

    ```sql
    -- 添加字段
    -- alter table student用于修改表student的结构； add 用于增加列，注意此处没有column关键字：小括号内是列及列的数据类型；用户可以一次性为表增加多个列，各列之间使用逗号进行分隔。
    alter table TABLE_NAME add (COLUMN DATA_TYPE);

    -- 修改已有的列
    -- modify（class_ jid varchar2（20）用 于修改表student中的已有列class_ id，实际相当于重新定义。
    alert table TABLE_NAME modify (COLUMN DATA_TYPE);


    -- drop column class_ id 用于删除已有列class_ id；需要注意的是，此处必须添加column选项，才能表示删除的目标是一个列。
    alter table TABLE_NAME drop column COLUMN_NAME;

    -- 重命名
    alter table TABLE_NAME rename column COLUMN_NAME to NEW_COLUMN_NAME;

    -- 转移表空间
    alter table TABLE_NAME move tablespace TABLE_SPACE_NAME;
    ```


### 删除表

```sql
drop table TABLE_NAME;
```

+ 有时，由于某些约束的存在，例如，当前表的主键被其他表用作外键，会导致无法成功删除。利用cascade constraints选项可以将约束同时删除，从而保证drop table 命令一定能够成功执行。示例3一11的使用语法应该修改为如下所示的代码。

```sql
drop table TABLE_NAME cascade constraints;
```

## 数据类型

字符型

### 固定长度字符串一 char（n）

char（n）指定变量或列的数据类型为固定长度的字符串。其中，n代表字符串的长度。当实际字符串的长度不足n时，Oracle 利用空格在右端补齐。当然，Oracle 不允许实际字符串的长度大于n。

数据库中列指定为char（n）类型时，n的最大值不能大于2000。否则，Oracle 将抛出错误，如示例6一1所示。

### varchar（n）
Oracle中提供了varchar（n）的数据类型。该类型是Oracle迎合工业标准中的varchar而制定的。该数据类型实际是一个可变长度字符串类型。也就是说，当实际字符串的长度不足时，不会使用空格进行填充。同样，实际字符串的长度也不允许超出n.
【示例6一2】当作为 列的数据类型出现时，\ varc char 的最大长度不能大于4000， 如下所示。

### varchar2（n）

与varchar（n）类型， varchar2（n）同样是可变长度的字符串类型。Oracle在工业标准之外，自定义了该数据类型。同时Oracle也提醒用户，尽量使用varchar2（n），而非varchar（n）。因为使用varchar2（n）可以获得Oracle向后兼容性的保证。
【示例6一3】当作为列的数据类型出现时，varchar2 的长度同样不能大于4000，如下所示。
    

#### varchar2（n）与char（n）的区别

varchar2（n）为可变字符串类型，而char（n）为 固定字符串类型。二者的区别在于是否使用空格来补齐不足的部分。

`select length(ename) from EMP;`

+ varchar2（n）与 char（n）的选择

    通过示例6一5可以看出，char（n）类 型的列通常占用较大的存储空间；而varchar2（n）类型的列占用的空间较小。所以，varchar2（n）类 型是在进行数据库设计时的一般选择。但这并不意味着char（n）类型应该被摒弃。相反，char（n）在效率方面要高于varchar2（n）。 这是因为可变长度的字符串类型在实际数据长度发生改变时，总需要不断调整存储空间。尤其是频繁修改数据，而数据长度也不断改变的情况下，这种效率的损耗尤其明显。

    大多数的应用程序，并不将数据库端的效率作为首要考虑的需求，而更倾向于较小的空间代价，因此一般使用varchar2（n）来定义列。而char（n）则是典型的“以空间换时间”，读者可以在实际开发中酌情选择。


### 数值类型

Oracle中的数值型仅有一种，即number类型。该类型的使用方法如下：

`number[(precision [, scale])]`

其中precision代表该数值型的精度；而scale则指定小数后的位数。由于precision 和scale均为可选，因此，既可以指定number类型的精度，也可以直接使用number类型进行声明。precision 的取值范围为1≤prevision≤38； scale 的取值范围为一84≤scale≤127。


在number类型中，小数位数scale可以为正数，也可以为负数。当scale为负数时，表示将数字精确到小数点之前的位数：当 scale为正数时，表示将数字精确到小数点之后的位数：当scale为0时，表示将数字精确到正数。

number类型中的精度是指可以标识数据精确度的位数。而数据的精确度，决定于精确到的位数。例如，对于数字12345.977 来说，当精确到小数点后两位，数据应为12345.98.此时的精度为7。因为共有7位数字对数据的准确度做出贡献。而当精确到小数点前两位，数据应为12300.此时的精度为3，因为共有3个数字对数据的准确度做出贡献一数字仅能以百为单位。


## 视图

+ 视图的本质

从关系代数理论上来说，数据表可以看作关系。这种关系往往代表了现实世界的真实实体。而关系可以通过各种运算（如交、差、并、投影）来获得新的关系。

在查询员工工资状况的实例中，可以通过表之间的关系运算获得财务人员所需的结果集合。该结果集具有临时性，一旦使用完毕，即可“丢弃”。这些结果数据，并不形成真正的数据表，也不会持久化到数据库中。视图也不存储查询的结果，但是存储了查询的定义。也就是说，对于关系运算的运算步骤进行存储。因此，视图的本质就是关系运算的定义。

+ 使用视图的场景

    1.封装查询

    视图是绝大部分数据库开发中都会使用的概念。使用视图大致有两个方面的原因。1.封装查询
    数据库虽然可以存储海量数据，但是在数据表设计上却不可能为每种关系创建数据表。例如，对于学生表，存储了学生信息，学生的属性包括学号、姓名、年龄、家庭地址等信息；而学生成绩表只存储了学生学号、科目、成绩等信息。现需获得学生姓名及成绩信息，那么就需要创建一个关系，该关系需要包含学生姓名、科目、成绩。但为该关系创建一个新的数据表，并利用实际信息进行填充，以备查询使用，，是不适宜的。因为这种做法很明显的造成了数据库中数据的大量冗余。

    视图则是解决该问题的最佳策略。因为视图可以存储查询定义（或者说关系运算），格那么，一旦使用视图存储了查询定义，就如同存储了一个新的关系。用户可以直接对视图中所存储的关系进行各种操作，就如同面对的是真实的数据表。


    2.灵活的控制安全性

    一个数据表可能含有很多列。但是这些列的信息，对于不同角色的用户，可访问的权限有可能不同。例如，在员工表中，可能存在着员工工号、员工姓名、员工年龄、员工职位、员工家庭住址、员工社会关系等信息。对于普通用户（例如普通员工），有可能需要访问员工表，来查看某个工号的员工的姓名、职位等信息，而不允许查看家庭住址、社会关系等信息；对于高级用户（例如人事经理），则需要关注所有信息。那么，这就涉及数据表的安全性。


+ 视图创建

    1.创建关系视图

    `create view VIEW_NAME as 查询语句｜关系运算 [with read only]`

    其中，create view 是创建关系视图的命令；其后紧跟视图名称； as 后面连接的是视图的查询定义（或者说关系运算） 。

    read only 意为创建自渎视图


    如：

    ```sql
    create view vw_ employees as
        select
        employee id, employee name
        from employees
    ```


![Text](http://qiniu.jiiiiiin.cn/a5ec8N.png)


视图一旦创建，其定义即可存在于数据库中。可以通过PL/SQL Developer 的Views窗口查看视图Vw_ EMPLOYEES在数据库中的信息，如图11一4所示。
右击VW_EMPLOYEES分支，在弹出的菜单中选择View选项，将弹出视图定义窗口。在该窗口中，可以查看视图VW_ EMPLOYEES的视图定义，如图11一5 所示。

+ 使用视图

    - 查询 `select  * from VIEW_NAME`

    - 更新视图数据：用户可以利用update语句更新视图中的数据，而视图本身并不存储数据。其数据来源于基础数据表。因此，更新视图数据，实际是更新基础表中的数据。

    - 插入同更新机制


    【示例11一5】 Oracle内置视图user_ updatable_ columns 定义了用户视图中各列的可更新情况。可以通过如下SQL语句进行查看。

    其中，TABLE_ NAME列为表名（在此，为视图名，这里也印证了Oracle往往将视图当做普通数据表处理）； COLUMN_ NAME列为视图中的列名； UPDATABLEJINSERTABLE和DELETABLE分别代表列的可更新、可插入以及可删除情况。

    对于更新操作，只要该列可更新，那么即可利用视图进行更新；而对于插入和删除操作，则必须所有列均可执行插入和删除操作，才能利用视图进行操作。


+ 修改视图

修改视图的过程即为重新定义视图的过程。可以通过首先删除视图，然后再次创建实现。另外，Oralce 也提供了一个专门的命令一create or replace view来重新定义视图。其语法形式如下所示。
        

`create or replace view 视图名称as查询语句|关系运算`

+ 2.删除视图
删除视图的动作实际为删除数据库中的对象操作，因此该操作为DML操作。如同删除数据表对象，删除视图也应该使用drop命令，其语法形式如下所示。

`drop view view name`


### 视图（内嵌/关系）和历史表选择

内嵌视图的特点在于无须创建真正的数据库对象，而只是封装查询，因此会节约数据库资源，同时不会增加维护成本。但是内嵌视图不具有可复用性，因此当预期将在多处调用到同一查询定义时，还是应该使用关系视图。
内嵌视图之所以称为内嵌，是因为它总是出现在较复杂的查询中，而其外层查询往往被称为父查询，因此，内嵌视图也可以看做子查询。

内嵌视图在处理大数据量查询时不具有优势。相对来说，使用临时表反而是更好的选择。临时表作为实实在在存在的数据库对象，可以通过创建索引等手段来更好地提高性能，这正是视图所不具备的。

总之，内嵌视图的优点为，节省数据库资源，不增加维护成本：而缺点为，不可复用及大数据量的查询效率较低等。读者可以根据实际情况在内嵌视图、关系视图和临时表之间进行取舍。


## 游标

当我们在使用大多数的DML语句，例如select语句、update语句等时，实际都是针对记录集合进行的操作一即 使这种操作利用了where 子句，将操作对象限制在唯一 一条记录。普通的DML语句很难实现对单条记录的精细控制。因此，游标的概念便应运而生。

游标类似于编程语言中指针的概念。开发者可以首先获取一 个记录集合，并将其封装于游标变量中。游标变量利用自身的属性，来实现记录的访问。例如，初始化的游标变量总是指向结果集合中的第一条记录。当游标下移时，便指向“当前记录”的下一条记录，此时，游标变量的“当前记录”也指向了新的记录。如此循环，开发者可以利用游标来访问记录集合中的每条记录。

针对每条记录，游标也提供了访问记录中各列的方式，从而将访问的粒度细化到数据表的原子单位。而更为重要的是，游标的使用总是在PL/SQL 编程环境中。加之OraclePL/SQL编程语言的强大，这使得获得的数据能够完成几乎任何复杂度的操作。
游标的主要类型分为静态游标和动态游标。而静态游标是常用的游标。静态游标又分为显式游标和隐式游标两类。但是，无论哪种游标，只是在开发过程中的使用方式不同，其实现原理都是完全相同的。

当前项目不常用，暂不记录;

## 序列

### 自动生成序号

很多时候，表设计者会将数据表的主键设计为一个与业务无关的数值型。这样既可以保证每个数据表都具有通用的主键，又剔除了主键与业务的相关性。但是，在应用层为列指定主键值显然不是一种好的选择。因此，很多数据库都会提供将列设置为自增类型，从而在数据库层面上解决该问题。自动生成序号策略要求在数据库层，无须人工干预即可获得序号。

在SQLServer和MySQL插入数据时，将主键列留空，那么数据库将自动为主键列赋值。

如：`auto_increment`

Oracle并未提供对列的属性进行设置，从而实现自增的功能，而是可以通过序列实现。通过序列实现时，用户必须将获得的值显式赋予主键列，如下所示。

```sql
create table test{
id integer primary key, name varchar(20)
);
insert into test (sequence_name.nextval,…);
```

在这里，sequence_ name.nextval 是利用序列来为主键列赋值。

+ 创建

序列（SEQUENCE）如同表、约束、视图、触发器等一样，是Oracle数据库对象之一。一旦创建，即可保存于数据库中，并可在适用场合进行调用。

创建序列，应该使用create sequence命令。忽略所有可选项，其语法形式如下所示。

`create sequence 序列名称;`

其中，create sequence为固定命令，其后紧跟序列名称；序列名称一般要与所服务对象具有一定的关联性，并添加seq后缀。

如：创建一 一个用于生成表employees 主键ID的序列，可以利用如下SQL语句。

`create sequence emp_seq`

指定初始值：`create sequence 序列名称 start with n`

+ 序列属性

![Text](http://qiniu.jiiiiiin.cn/7n1s9h.png)

序列的主要属性包括minvalue、maxvalue、 increment by、cache 和cycle。在序列创建时，如果未指定这些属性的值，那么Oracle将为其赋予默认值。当然，如同其他数据库对象一样，可以通过alter命令修改这些属性。

序列的minvalue和maxvalue属性用于指定序列的最小值和最大值。序列最小值的意义在于限定startwith和循环取值时的起始值：而最大值则用于限制序列的nextval属性所能达到的最大值。序列的最小值默认为I，而最大值默认为1E27，即102。

【示例15一5】可以利用alter命令修改序列的最小值，其语法形式如下所示。
```sql
alter sequence 序列名称minvalue最小值
```

其中，minvalue 选项用于重置序列的最小值。
一个序列的最小值不能大于当前值（即currval属性的值），否则，Oracle 将抛出错误。例如，序列employee_ seq的当前值为8， 尝试将其最小值设置为9。

+ 删除

`drop sequence 序列名称`

+ 查询

因为创建的序列是一一个实实在在的数据库对象，因此可以在数据字典中获得其信息。与序列相关的视图为user_ objects 和user_ sequences。可以利用如下SQL语句进行查看。

`select * from user_objects where object_name='EMPSEQ'`

在视图user_ sequences的查询结果中，会发现min_ _value、 max_ value和increment_ by列，其值均为创建序列时的默认值。min_ value 指定序列的最小值； max_ _value 指定最大值，1E27为科学计数法数字，即十进制的1027； increment_ _by 指定序列每次增长的步长，默认值为1。


+ 使用

对于序列，有两个重要的属性一currval 和nextval。 其中currval 用于获得序列的当前值，而nextval则用于获得序列的下一一个值。每次调用 nextval，都会使序列的当前值增加单位步长（默认步长为1）。获得currval属性与nextval属性值的调用形式为：

```sql
序列名称.currval
序列名称.nextval

-- 在序列创建之后，应该首先使用seq.nextval，然后才能够使用seq. currval。否则，Oracle 将抛出错误

select emp_seq.nextval from dual;

select emp_seq.currval from dual;

--作为主键，注意序列的值需要和当前表中的ID值相匹配，即不能重复
insert into emp values(emp_seq.nextval, ...);
```



## 表空间相关


> [oracle数据库_实例_用户_表空间之间的关系](https://www.cnblogs.com/zjhs/p/3147905.html)

![Text](http://qiniu.jiiiiiin.cn/0ByLt0.png)

> [Oracle - 数据库的实例、表空间、用户、表之间关系](https://www.cnblogs.com/zouhao/p/3627522.html)
> 完整的Oracle数据库通常由两部分组成：Oracle数据库和数据库实例。 1) 数据库是一系列物理文件的集合（数据文件，控制文件，联机日志，参数文件等）； 2) Oracle数据库实例则是一组Oracle后台进程/线程以及在服务器分配的共享内存区。


+ 表空间很重要的一个作用就是规划数据表。也就是说，每个数据表都是某个表空间的子对象。数据表的真实数据也是存在于表空间的物理文件中。因此，了解表空间的使用规则，对于明确Oracle数据库结构有着重要意义。

+ 每个用户登录数据库时所作的建表动作，如果未显式指定将表创建于哪个表空间中，都会自动创建于该用户的默认表空间。默认表空间相当于用户的工作空间。

+ 普通用户的默认表空间有两种来源，一是创建用户时分配或者后期手动修改，二是，
从未进行分配或者修改动作，那么则使用数据库的默认表空间。
+ Oracle 10g数据库默认表空间为USERS，因此，未指定默认表空间而创建的用户，都将使用表空间USERS。



### 查询表空间


```sql
-- 视图dba_data_files可以用于查看当前数据库中表空间及其物理文件的完整路径。
select tablespace_name from dba_data_files;

-- 获得数据库中所有用户的默认表空间 
-- 分析查询结果可知，系统用户sys及system，其默认表空间为表空间SYSTEM：而普通用户的默认表空间为USERS。
select user_id, username, default_tablespace from dba_users order by user_id;
```

## 用户权限相关

> [Oracle用户和模式的区别](https://database.51cto.com/art/201010/231679.htm)


### 用户

+ 在Oracle数据库中，存在着视图dba__users.该视图存储了所有用户的基本信息，我们搜寻视图内容来查看Oracle中的用户概况。

    `select username, password, account_status, default_tablespace from dba_users;`

    分析查询结果可知，当前数据库存在着23个用户；其中，username 代表用户名，也是用户在数据库中的唯一身 份标识； account status 代表该用户当前的账号状态一OPEN代表当前用户可用，EXPIRED&LOCKED则代表当前用户已过期或锁定；DEFAULT_ TABLESPACE和TEMPORARY_ TABLESPACE分别指定当前用户登录数据库后，默认表空间和临时表空间。

+ 创建用户

    对于开发人员来说，并不会经常使用系统用户登录数据库。因为系统用户的权限范围较大，如果出现失误，可能对数据库造成较大伤害。因此，开发人员往往会使用特定的用户进行开发任务。创建新用户的语法如：

    `create user 用户名 identified by 密码 default tablespace 表空间;`

    其中，create user命令用户创建新的用户，并指定用户名； identified by选项是必需的，用于指定新用户的密码； default tablespace用于指定新建用户的默认表空间，新用户登录之后，所有操作均默认在该表空间进行。

    数据库创建开始时，可以利用系统用户登录，并创建普通用户。

+ 系统用户

    系统用户sys和system是Oracle数据库默认创建的用户。用户sys用户角色为sysdba（数据库管理员），是数据库中权限最高的用户，可以进行任意操作而不受限制。system用户角色为sysoper （数据库操作员），权限仅次于sys用户。


#### 修改用户密码

`alter user 用户名 identified by "密码"`

+ 修改时候报错：“ORA-00988: missing or invalid password(s)”

    创建账号或修改账号密码时有可能会遇到ORA-00988: missing or invalid password(s)，那么什么情况下会遇到这种错误呢？ 一般是因为密码的设置不符合命名规范：

    1：密码是关键字，但是没有用双引号包裹起来。

    2：密码以数字开头，但是没有用双引号包裹起来

    3：密码包含特殊字符，并且没有用双引号包裹起来。


### 权限

权限（Privilege） 是Oracle中控制用户操作的主要策略。Oracle 中的权限分为两种，系统权限和对象权限。

系统权限是Oracle内置的、与具体对象无关的权限类型。这些权限不指向具体对象，而是针对某种操作而言。例如，创建表的权限，当表未创建时，自然无从谈对针对特定表的权限。


#### 系统权限


+ 1.获得系统权限信息
视图dba_ sys_ privs 描述了各种系统权限及权限分配情况。

其中，列grantee是指权限的拥有者；列privilge是系统权限的名称： admin_ _option 表示该系统权限拥有者是否可以将权限传播出去。

该查询结果显示了用户system所直接拥有的系统权限。这里之所以说“直接拥有”，是因为grantee 也可以是角色，一旦某个用户属于某个角色，便“间接”拥有了角色的所有权限。

+ 分配系统权限

    当一个用户登录数据库之后，需要和数据库建立会话，此时便需要create session权限。（2）为用户分配权限应该使用命令grant，其语法形式如下所示。

    `grant privilege to grantee`


    其中grant 用于分配权限； privilege 为权限名称； to grantee 用于指定权限分配的对象一一 般为用户或者角色。这里暂时讨论用户。将 create session 的权限分配给用户test的SQL语句如下所示（当然，此时应该利用用户system来进行权限分配工作）。

    `grant create session to test;`

    其中grant 用于分配权限； privilege 为权限名称； to grantee 用于指定权限分配的对象一 一般为用户或者角色。这里暂时讨论用户。将create session的权限分配给用户test的SQL语句如下所示（当然，此时应该利用用户sys stem .来进行权限分配工作）。

+ 回收权限

    对于已分配的权限，可以利用revoke命令收回。其语法形式如下所示。

    `revoke privilege from grantee`

    revoke命令用户收回权限： privilege 为权限名称； from grantee 指定从哪个用户或角色收回权限。

    如：可以利用revoke命令收回用户test 的权限。.

    `revoke create session, create table from test;`

#### 对象权限

对象权限是指用户在已存在对象.上的权限。这些权限主要包括以下几种：口select： 可用于查询表、视图和序列。.
 + insert： 向表或视图中插入新的记录。
 + update：更新表中数据。
 + delete： 删除表中数据。
 + execute： 函数、存储过程、程序包等的调用或执行。
 + index：为表创建索引。
 + references： ：为表创建外键。
 + alter：修改表或者序列的属性。

    在所有对象权限中，最主要同时也最常用的是针对数据表的权限。查看一个用户针对某个数据表的权限，可以通过视图user_ _tab_ privs 或者dba_ _tab_ privs。 视图dba_ tab_ _privs 的表结构如下：


    其中，列name描述了拥有权限的用户或者角色；列owner描述了对象的拥有者；列table_ name描述了对象名称；列grantor 描述了分配权限的用户（权限的传播者）； privilege描述了权限的名称；grantable描述了权限是否可分配；hierarchy描述了权限是否将对象的所有子对象的对应权限分配给用户或角色。

+ 分配

    与系统权限类似，为用户分配对象权限也应该使用grant命令。其语法形式如下所示。

    `grant 权限 on 对象 to 用户`

    可以看出，为用户分配对象权限增加了一个选项on，该选项用于指定权限所对应的对象。以下步骤演示了分配对象权限的整个过程。
    
    （3）利用system用户登录数据库，并分配表employees的select权限给用户test，并从视图dba _tab_ privs 中查看用户test 的对象权限。

     ```sql
        SQL》 grant selecton employees to test；
        Grant succeeded
        

        --（5）利用grant命令同样可以为用户分配表的update/insert 权限，如下所示。
        -- grant update， insert on employees to test一 次性将 update 和insert 权限分配给表employees。多个权限之间使用逗号进行分隔。

        SQL》 grant update， insert on employees to test；
        Grant succeeded

        -- 查询此时用户test 的对象权限权限信息。
        SQL》 select grantee， owner，
        table_name， grantor， privilege from dba_tabprivs where lower (grantee) ='test'；
     ```


     + 分配所有权限

        假设表system.employees对用户test 是完全开放的。也就是说，用户test具有该表上的所有权限。那么用户system进行权限分配的工作可以使用all 关键字，以便直接将所有权限一次性分配给用户test。相应的SQL语句如下所示。

        ```sql
        SQL》 grant all on employees to test；
        Grant succeeded
        ```
        
        此时，用户test 便具有了表system.employees的所有权限。

         从查询结果可以看出，一个表能分配给其他用户的权限总共有11种。但是需要注意的是，我们所说的为用户分配对象权限，这里的对象一般指其他Schema中的对象。这是因为用户是本身Schema内部所有对象的拥有者，默认拥有所有权限。.

     + 收回权限

        利用revoke命令可收回用户的对象权限。其语法形式如下所示。
        
        `revoke 对象 权限 on 对象 from 用户`

        对象的拥有者可以收回其他用户的对象权限。以收回用户test 针对表system.employees 的update和insert权限为例，相应的SQL语句如下所示。
    
        ```sql
        SQL》 revoke update， insert on employees from test；
        Revoke succeeded
        ```

        相较于update和insert权限，添加了with grant option选项的select 权限在收回时会稍稍复杂些。当收回用户test的select 权限之后，同时也收回了用户test _user 的select权限，如下所示。

        ```sql
        SQL> revoke select on employees from test;
        Revoke succeeded
        ```

        分析查询结果可知，当收回用户test 的select 权限之后，用户test_ user 的select 权限也被收回。这与利用admin option传播的系统权限完全不同。
        

### 角色

利用grant命令为用户分配权限是一件非常耗时的工作，尤其是当数据库中用户众多，而且权限关系比较复杂时。有鉴于此，Oracle提供了角色这一策略协助数据库管理员更加灵活地实现权限分配。

角色是权限的集合。一个角色可能包含多个权限信息。在Oracle中，可以首先创建一个角色，该角色包含了多种权限。然后将角色分配给多个用户，从而在最大程度上实现复用性。

#### 创建自定义“数据库”

> [Oracle数据库基本知识-原理，实例，表空间，用户，表](https://www.cnblogs.com/lgx5/p/11549622.html)

TODO

+ 创建实例

+ 创建表空间

+ 创建用户

+ 建表





## 索引
    索引在大表查询时可以显著提高查询速度，但并非所有数据表都适合建立索引。这是因为索引的创建需要较大的开销。为一个数据表创建索引只是开销的一部分， 当数据表中的数据发生改变时，往往需要维护索引。这里的维护，针对数据的增加、删除、修改，所进行的具体操作也不相同。本节待结合数据的变更，来分析维护索引的开销。
+ 创建

```sql
-- 在Oracle数据表上创建索引，应使用create index命令，其使用语法如下所示。
create index 索引名称 on 表名（列名）
```

+ 使用场景

    通过以_上对索引的描述可知，索引并非多多益善。因此，在以下场景下，不宜为表创建索引。

    1.数据量较小的表

    数据量较小的表，执行全表搜索的时间已经可以忽略。使用索引并不能提高数据查询的响应速度，反而要为维护索引付出代价。

    2.有着频繁数据变更的表不宜使用索引

    对于频繁变更的数据表不宜使用索引。数据变更往往会由于维护索引而付出较大代价。例如，交易数据往往非常频繁，而如果在表中某列创建了索引，那么将影响插入数据的效率。





