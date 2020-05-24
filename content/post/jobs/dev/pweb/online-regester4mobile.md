---
title: "Online Regester4mobile"
date: 2020-04-28T15:11:27+08:00
draft: true
---

个人网银在线注册（手机银行）
<!--more-->

<!-- vim-markdown-toc GFM -->

* [流程](#流程)
    * [交易](#交易)
* [业务逻辑](#业务逻辑)
    * [prepare](#prepare)
    * [subimit](#subimit)
        * [如果未开通网银](#如果未开通网银)

<!-- vim-markdown-toc -->

## 流程

### 交易

![Text](http://qiniu.jiiiiiin.cn/Y9zYxo.png)

+ GenSerRan.do

    - transcode `https://ebank.ynrcc.com/pweb/GenSerRan.do?LoginType=K&BankId=9999&_locale=zh_CN`

    - qry str

        ```xml
        LoginType	K
        BankId	9999
        _locale	zh_CN
        ```
    - resp

    ```json
    {
        "_replaceJsonviewTrs": "GenSerRan",
        "BSMobileDeviceId": "9CB26B23774E66A40AC7756DF859D15A",
        "ReturnMessage": "",
        "BankId": "9999",
        "SerRan": "AWN6aeS/Jc4LSlrEQdbj0A==",
        "LoginType": "K",
        "ReturnCode": "000000",
        "_TransDate": "2020-04-28",
        "_locale": "zh_CN"
    }
    ```
+ UserIdNoQry

    - transcode `https://ebank.ynrcc.com/pweb/UserIdNoQry.do?LoginType=K&BankId=9999&_locale=zh_CN`

    - req

        ```xml
        UserName	赵军
        IdNo	530326198608050015
        ```

    - resp

        ```json
        {
            "_replaceJsonviewTrs": "UserIdNoQry",
            "BSMobileDeviceId": "9CB26B23774E66A40AC7756DF859D15A",
            "ReturnMessage": "",
            "List": [{
                "AcNo": "6223****3243"
            }, {
                "AcNo": "6231****2077"
            }],
            "UserName": "赵军",
            "RetCode": "0",
            "BankId": "9999",
            "IdNo": "530326198608050015",
            "LoginType": "K",
            "ReturnCode": "000000",
            "_TransDate": "2020-04-28",
            "_locale": "zh_CN"
        }
        ```
        
+ PublicGenSMSOTPToken4M

    - transcode `https://ebank.ynrcc.com/pweb/PublicGenSMSOTPToken4M.do?LoginType=K&BankId=9999&_locale=zh_CN`
        
    - req

        ```
        MobilePhone=15398699939&RawTransactionId=OnlineRegister
        ```
        
    - resp

        ```json
        {
            "_replaceJsonviewTrs": "PublicGenSMSOTPToken4M",
            "MobilePhone": "15398699939",
            "Content": "MTUzKioqKjk5Mzk=",
            "RawTransactionId": "OnlineRegister",
            "BankId": "9999",
            "LoginType": "K",
            "_ShortMessageFlag": "true",
            "_TransDate": "2020-04-28",
            "_locale": "zh_CN",
            "ReturnMessage": "",
            "BSMobileDeviceId": "9CB26B23774E66A40AC7756DF859D15A",
            "MobilePhoneLast": "153****9939",
            "ReturnCode": "000000"
        }
        ```
        
+ GenSerRan

    - transcode `https://ebank.ynrcc.com/pweb/GenSerRan.do?LoginType=K&BankId=9999&_locale=zh_CN`

    - resp

        ```json
        {
            "_replaceJsonviewTrs": "GenSerRan",
            "BSMobileDeviceId": "9CB26B23774E66A40AC7756DF859D15A",
            "ReturnMessage": "",
            "BankId": "9999",
            "SerRan": "sj9aEyhholiSuI7ngRnGGg==",
            "LoginType": "K",
            "ReturnCode": "000000",
            "_TransDate": "2020-04-28",
            "_locale": "zh_CN"
        }
        ```
        
+ OnlineRegisterForMobileConfrim

    - transcode `https://ebank.ynrcc.com/pweb/OnlineRegisterForMobileConfrim.do?LoginType=K&BankId=9999&_locale=zh_CN`

    - req

        ```json
        MobilePhone	15398699939
        TrsPassword	sj9aEyhholiSuI7ngRnGGg==~GM~uo0JBOirJF2VpegD2Zp16g==~GM~3M/8onGzKLkwLnJTEovzjiUdGSzIpQPI8x/CLMd6BAggPjVTMqXOPDqg+e3yFqR01RP9qgwdHsHnxuuVn61hQPbbQxxjEaNVQnSXsounOQYqTdxQZ9fofc0QWAeCCxcHh9se22fr9cbu3iAZh51hBg==
        AcName	赵军
        IdType	52
        IdNo	530326198608050015
        index	0
        _sMSOTPTokenName	683626
        ```
        
    - resp

        ```json
        // error

        {
            "ReturnMessage": "5omL5py66ZO26KGM5bey57uP5byA6YCa77yM5LiN5YWB6K646YeN5aSN5byA6YCa",
            "_JnlNo": null,
            "ReturnCode": "validation.mobileebank.opened",
            "_TransDate": "2020-04-28"
        }
        
        ```

## 业务逻辑

### prepare

+ 校验卡片信息，区分借贷记卡，从前置查询注册用户信息：
    - 根据卡类型来区分去查哪里：acType C为信用卡，判断是根据卡号前几位
    - 查询核心客户信息：`pcommon.CifInfoQueryByAcct`
    - 校验用户在注册时候填写的证件号/姓名/手机号
+ 检验是否注册网银或手机银行，如果已经开通手机银行或者状态异常则报错提示
+ 验证密码，如果配置不为空 `BankSysRule passwordValidateRule=cachedBankRuleAttribute.getResourceWithNull(context.getString(Dict.BANKSEQ), CONSMSG.RULETYPE_TRSDEF, "POnlineRegister."+context.getData(Dict.ACTYPE)+".PasswordValidate");`

### subimit

#### 如果未开通网银


+ 从前置或者银数查询客户信息 `getAcctInfo`
+ 检查账号类型是否允许注册，规则 `BankSysRule canRegisterAcTypeRule= (BankSysRule)cachedBankRuleAttribute.getSetRuleWithNull(context.getString(Dict.BANKSEQ),CONSMSG.RULETYPE_TRSDEF, "CanRelaAddAcType");` 中存储了支持注册的账号类型

    ![Text](http://qiniu.jiiiiiin.cn/sRoIsW.png)

+ 检查手机号：`网银注册手机号 1.注册时检查，如果超过配置，报“注册手机号码大于银行规定手机号码数”`
+ 检查账号状态

    ```java
    public static final String ACSTATE_0="0"; //正常
    public static final String ACSTATE_1="1"; //销户
    public static final String ACSTATE_10="10"; //作废核销
    public static final String ACSTATE_11="11"; //密码挂失
    public static final String ACSTATE_12="12"; //睡眠户
    public static final String ACSTATE_13="13"; //密码锁定
    public static final String ACSTATE_14="14"; //质押
    public static final String ACSTATE_15="15"; //存款证明
    public static final String ACSTATE_16="16"; //其他
    public static final String ACSTATE_2="2"; //挂失结清
    public static final String ACSTATE_3="3"; //冻结
    public static final String ACSTATE_4="4"; //挂失
    public static final String ACSTATE_5="5"; //止付
    public static final String ACSTATE_6="6"; //关闭
    public static final String ACSTATE_7="7"; //临时挂失
    public static final String ACSTATE_8="8"; //正式挂失
    public static final String ACSTATE_9="9"; //冲正核销
    public static final String ACTYPE_0="0"; //一户通
    public static final String ACTYPE_1="1"; //活期存折
    public static final String ACTYPE_2="2"; //定期（单笔）
    public static final String ACTYPE_3="3"; //通知存款
    public static final String ACTYPE_4="4"; //贷款
    public static final String ACTYPE_5="5"; //国债账户
    public static final String ACTYPE_9="9"; //其他
    public static final String ACTYPE_A="A"; //协定存款
    public static final String ACTYPE_C="C"; //信用卡
    public static final String ACTYPE_D="D"; //一卡通
    public static final String ACTYPE_P="P"; //一本通存折
    public static final String ACTYPE_S="S"; //活期一本通
    public static final String ACTYPE_T="T"; //定期一本通
    ```
    
+ 开通网银

    - 网银开户数据库操作： 1，插入Cif表 2，插入user表 3，插入加挂账号表
    - 以身份证作为userid
    - 开通手机银行的时候网银默认USERSTATE为1 销户状态，手机银行状态为0开户状态
    - 设置账号状态为正常
    - 先要判断注册的idtype和idno是否已经存在网银客户。如果存在则查pcif表得到cifseq。如果不存在则从顺序号增加一个，如果存在就更新信息
    - 先插入插入cif表 `register.insertPCifInfo`

        ```xml
        <insert id="insertPCifInfo" parameterClass="java.util.HashMap">

		insert into PCIF
                (CIFSEQ,
                IdType,
                IdNo
                <dynamic prepend=",">
                    <isNotEmpty prepend="," property="CifName">CIFNAME</isNotEmpty>
                    <isNotEmpty prepend="," property="CifState">CIFSTATE</isNotEmpty>
                    <isNotEmpty prepend="," property="Addr">ADDR</isNotEmpty>
                    <isNotEmpty prepend="," property="Phone">PHONE</isNotEmpty>
                    <isNotEmpty prepend="," property="ZipCode">ZIPCODE</isNotEmpty>
                    <isNotEmpty prepend="," property="Email">EMAIL</isNotEmpty>
                    <isNotEmpty prepend="," property="MobilePhone">MOBILEPHONE</isNotEmpty>
                    <isNotEmpty prepend="," property="Sex">SEX</isNotEmpty>
                </dynamic>)
                values
                (#CifSeq#,
                #IdType#,
                #IdNo#
                <dynamic prepend=",">
                    <isNotEmpty prepend="," property="CifName">#CifName#</isNotEmpty>
                    <isNotEmpty prepend="," property="CifState">#CifState#</isNotEmpty>
                    <isNotEmpty prepend="," property="Addr">#Addr#</isNotEmpty>
                    <isNotEmpty prepend="," property="Phone">#Phone#</isNotEmpty>
                    <isNotEmpty prepend="," property="ZipCode">#ZipCode#</isNotEmpty>
                    <isNotEmpty prepend="," property="Email">#Email#</isNotEmpty>
                    <isNotEmpty prepend="," property="MobilePhone">#MobilePhone#</isNotEmpty>
                    <isNotEmpty prepend="," property="Sex">#Sex#</isNotEmpty>
                </dynamic>
                )
            </insert>
            ```
    - 插入PUser表
        - 加密密码 `pinModuleDelegate.encrypt(uniqueIdResolver.resolve(finalContext), password ,finalContext.getString(Dict.BANKID));`
        - 插入数据 `mobile.insertPUserInfo4M`

            ```xml
            <insert id="insertPUserInfo4M" parameterClass="java.util.HashMap">
                insert into PUSER
                (USERSEQ,
                CIFSEQ,
                USERID,
                USERSTATE
                <dynamic prepend=",">
                    <isNotEmpty prepend="," property="EbankTrsPassword">EBANKTRSPASSWORD</isNotEmpty>
                    <isNotEmpty prepend="," property="FirstLoginState">FirstLoginState</isNotEmpty>
                    <isNotEmpty prepend="," property="MobileEbankState">MobileEbankState</isNotEmpty>
                    <isNotEmpty prepend="," property="MobileEbankOpenDate">MobileEbankOpenDate</isNotEmpty>
                    <isNotEmpty prepend="," property="WapPassword">WapPassword</isNotEmpty>
                </dynamic>
                )
                values
                (#UserSeq#,
                #CifSeq#,
                #UserId#,
                #UserState#
                <dynamic prepend=",">
                    <isNotEmpty prepend="," property="EbankTrsPassword">#EbankTrsPassword#</isNotEmpty>
                    <isNotEmpty prepend="," property="FirstLoginState">#FirstLoginState#</isNotEmpty>
                    <isNotEmpty prepend="," property="MobileEbankState">#MobileEbankState#</isNotEmpty>
                    <isNotEmpty prepend="," property="MobileEbankOpenDate">#MobileEbankOpenDate#</isNotEmpty>
                    <isNotEmpty prepend="," property="WapPassword">#WapPassword#</isNotEmpty>
                </dynamic>
                )
            </insert>
            ```
    - 插入PBankCif表
      `register.insertPBankCifInfo`，涉及PBANKCIF，客户手机银行的开户机构相关信息

    - 插入PAccount表

        `register.insertPAccountV2`

    - 插入PUserAccount表

        用户和账号关联表

    - 设置个人单笔限额 

        `setting.insertMoblieLimit` 涉及puserrule表

    - 设置个人单日限额

        `setting.insertMoblieLimit` 涉及 puserrule 表

    - 插入PUserProductGroup

        + 注册个人手机银行的时候，插入银行产品组中定义的数据：

            `select a.BankSeq,a.PrdGrpId from BankProductGroup a,Bank b,ProductGroup c where a.BankSeq=b.BankSeq and b.BankId=#BankId# and c.PrdGrpId=a.PrdGrpId and c.UserType='2'`

            产品组id和银行seq查询出来，再关联上用户seq，批量插入到该表中；


    - 把信息提交核心 `finalContext.setData(Constants.HOST_TRANSACTION_CODE,"pcommon.CifRegister");`

                



