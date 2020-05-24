---
title: "Rule"
date: 2020-05-01T16:51:07+08:00
draft: true
---

记录pe中规则表相关内容
<!--more-->


<!-- vim-markdown-toc GFM -->

* [针对某个字段是否需要进行style校验相关](#针对某个字段是否需要进行style校验相关)
* [StylePattern 针对某个字段是否匹配某个正则（值是否符合正则要求）](#stylepattern-针对某个字段是否匹配某个正则值是否符合正则要求)
* [TrsDef 交易定制](#trsdef-交易定制)
* [puserrule 个人用户规则表](#puserrule-个人用户规则表)

<!-- vim-markdown-toc -->

## 针对某个字段是否需要进行style校验相关

+ 在style的设置中，一般如果该style标注的字段，需要通过数据库来配置是否开启校验，都会在style上面添加
  `ruleFilter`
+ 这个validator会先读取数据库对应字段有没有配置“是否需要校验”的标示，这种时候就会涉及到规则表，或者说
  `cachedBankRuleAttribute`

    `BankSysRule bankSysRule = this.cachedBankRuleAttribute.getResourceWithNull(user, "FieldFilter", ruleId);`

    也就是说规则表中 ruleType 有一个字段过滤是专门针对这个需求来做的；
+ 在对应的配置中以`Y/N`来进行标示

    ![Text](http://qiniu.jiiiiiin.cn/uR8rGR.png)
+ 这样如果动态配置了`N`，则当前请求的当前字段的style校验将会被跳过，字段的value即req上来的值；

## StylePattern 针对某个字段是否匹配某个正则（值是否符合正则要求）

+ 如果需要对请求当中某个字段进行正则匹配（判断是否满足要求）
+ 对应字段的style中一般会使用 `rulePatternValidator`

    如： `<param name="rulePattern">^[A-Za-z0-9\u4E00-\u9FBB\u3400-\u4DBF\uF900-\uFAD9\u3000-\u303F\u2000-\u206F\uFF00-\uFFEF]{1,60}$</param>`

+ 而这里的正则，也可以设置在rule规则表中动态配置：

    ```java
        String trsId = context.getTransactionId();
        String productId = this.rolePool.getProductIdByTrsCode(trsId);
        String ruleId = (productId == null ? trsId : productId) + '.' + fieldName;
        IbsUser user = (IbsUser)context.getUser();
        BankSysRule bankSysRule;
        String tmpStr;
        if (user != null) {
            bankSysRule = this.cachedBankRuleAttribute.getResourceWithNull(user, "StylePattern", ruleId);
            if (bankSysRule == null) {
                bankSysRule = this.cachedBankRuleAttribute.getResourceWithNull(user, "StylePattern", fieldName);
            }
    ```
    
+ 而得到正则之后，就会使用req对应字段的value进行匹配，如果匹配不通过，则抛出异常终断请求：

    ```java
        if (bankSysRule != null) {
            patternStr = bankSysRule.getRuleDef().trim();
        } else if (attributes != null) {
            tmpStr = (String)attributes.get("rulePattern");
            if (tmpStr != null) {
                patternStr = tmpStr;
            }
        }

        if (patternStr == null) {
            throw this.error("pattern_is_not_defined", new Object[]{fieldName});
        } else {
            Pattern pattern = PatternPool.getPattern(patternStr);
            Matcher matcher = pattern.matcher(value.toString());
            if (!matcher.matches()) {
                throw this.error(message, new Object[]{name});
            } else {
                return value;
            }
        }
    ```
   
## TrsDef 交易定制

   为某个交易的特定用途，在数据库定义一些配置；

   如：

    ```java
    // 根据卡柄判断是否贷记卡
    BankSysRule creditCardStyleRule = cachedBankRuleAttribute.getResourceWithNull(context.getString(Dict.BANKSEQ), CONSMSG.RULETYPE_TRSDEF, "CreditCard.AcNoStartWith");
    if(creditCardStyleRule != null) {
        String creditCardStyle = creditCardStyleRule.getRuleDef();
        String[] styleList = creditCardStyle.split(",");
        for(int i = 0; i < styleList.length; i ++) {
            if(acNo.startsWith(styleList[i])) {
                bankAcType = "M4";
                acType = "C";
                context.setData(Dict.BANKACTYPE, bankAcType);
                context.setData(Dict.ACTYPE, acType);
                context.setData("AcctNo", context.getData(Dict.ACNO));
            }
        }
    }
    ```
    
![Text](http://qiniu.jiiiiiin.cn/z2jE1k.png)

## puserrule 个人用户规则表

```sql
CREATE TABLE PUSERRULE(
    USERSEQ NUMBER(0) NOT NULL,
    RULEID VARCHAR2(64) NOT NULL,
    RULETYPE VARCHAR2(16) NOT NULL,
    USERTYPE CHAR(1) DEFAULT 2 NOT NULL,
    RULEDEF VARCHAR2(1024),
    RULESCRIPT VARCHAR2(2056),
    PRIMARY KEY (USERSEQ,RULEID,RULETYPE,USERTYPE)
);;

COMMENT ON COLUMN PUSERRULE.USERSEQ IS '用户序号';;
COMMENT ON COLUMN PUSERRULE.RULEID IS '规则ID';;
COMMENT ON COLUMN PUSERRULE.RULETYPE IS '规则类型';;
COMMENT ON COLUMN PUSERRULE.USERTYPE IS '用户类型';;
COMMENT ON COLUMN PUSERRULE.RULEDEF IS '规则定义';;
COMMENT ON COLUMN PUSERRULE.RULESCRIPT IS '规则脚本';;
```

+ 添加一些个人设置，如个人手机银行注册的时候，添加“设置个人单笔限额”

    ![Text](http://qiniu.jiiiiiin.cn/4jmmCl.png)

