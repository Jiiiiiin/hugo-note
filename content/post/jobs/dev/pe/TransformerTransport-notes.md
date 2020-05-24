---
title: "TransformerTransport Notes"
date: 2020-03-31T22:20:31+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [TransformerTransport 联机交易发送器](#transformertransport-联机交易发送器)
    * [接口](#接口)
    * [主逻辑](#主逻辑)
    * [TransformerFactory分析](#transformerfactory分析)
        * [报文变换器对象创建过程](#报文变换器对象创建过程)
    * [格式化报文时候的关键日志](#格式化报文时候的关键日志)
    * [CSHeadFormatter分析](#csheadformatter分析)
* [TCPR001.SimpleXMLTcpTransport分析](#tcpr001simplexmltcptransport分析)
* [xmlPacketParser 分析](#xmlpacketparser-分析)

<!-- vim-markdown-toc -->

## TransformerTransport 联机交易发送器

```java
<transport id="TransformerTransport" class="com.csii.ibs.common.TransformTransport">
    <ref name="transformerFactory">TransformerFactory</ref>
    <ref name="transport">${csxml.TransformerTransport.transport}</ref>
    <param name="formatName">OutboundPacket</param>
    <param name="parseName">xmlPacketParser</param>
    <param name="debug">${csxml.TransformerTransport.debug}</param>
    <param name="dumpPath">${csxml.TransformerTransport.dumpPath}</param>
    <ref name="headFormatter">CSHeadFormatter</ref>
</transport>

```

定义：`/Users/jiiiiiin/Documents/Develop/eclipse-workspace/pcommon/src/config/outbound/csxml/transformer.xml`

### 接口

```java
package com.csii.pe.service.comm;

import com.csii.pe.service.Service;

public interface Transport extends Service {
  Object submit(Object var1) throws CommunicationException;
}

```

### 主逻辑

```java
    public Object submit(Object input) throws CommunicationException {
        setInputData((Map)input);

        try {
            //详见本文 TransformerFactory分析
            Transformer formater = this.transformerFactory.getTransformer(this.formatName);
            if (this.headFormatter->"CSHeadFormatter" != null) {
                // 相见本文 CSHeadFormatter分析
                input = this.headFormatter.format(input, (Map)input);
            }

            // TODO 待调试
            // 将xml和dataMap进行结合，做成字节流
            Object toSend = formater.format(input, (Map)input);

            //...
            long counter = (long)(this.globalCounter++);
            // 如果需要调试上传报文，可以打开这个配置
            if (this.debug) {
                try {
                    FileOutputStream fout = new FileOutputStream(this.dumpPath->"csxml.TransformerTransport.dumpPath=/Users/jiiiiiin/tmp/log/ebank/pweb" + '/' + this.formatName ->"<param name="formatName">OutboundPacket</param>" + counter + (new Time(System.currentTimeMillis())).toString().replace(':', '_'));
                    fout.write((byte[])toSend);
                    fout.flush();
                    fout.close();
                } catch (Exception var17) {
                    var17.printStackTrace();
                }
            }

            // 详见 TCPR001.SimpleXMLTcpTransport 分析
            // 得到一个流对象
            Object result = this.transport.submit(toSend);
            result = this.getResult(result);
            //
            返回只会在action中被`this.returnCodeValidator.check(fromHost);`进行是否为业务成功调用
            if (result != null) {
                if (this.debug) {
                    try {
                        FileOutputStream fout = new FileOutputStream(this.dumpPath + '/' + this.parseName + counter + (new Time(System.currentTimeMillis())).toString().replace(':', '_'));
                        fout.write((byte[])result);
                        fout.flush();
                        fout.close();
                    } catch (Exception var16) {
                        var16.printStackTrace();
                    }
                }

                //...

                InputStream in = new ByteArrayInputStream((byte[])result);
                Transformer parser = this.transformerFactory.getTransformer(this.parseName-> "<param name="parseName">xmlPacketParser</param>");
                Object object;
                Object var11;

                //...
                // 详见 xmlPacketParser 分析
                // 得到一个解析之后的map
                object = parser.parse(in->路由返回的字节流响应数据, (Map)input->当前上下文dataMap);
                // 可以在这里对联机响应数据做“最优先”的处理，如添加字段/修改字段内容等操作
                // 如pweb目前就在这里对`retMap.put("_RejMsg",_RejMsg+"[R]")`添加了一个统一标示
                object = handResult(object);
                var11 = object;
                return var11;
            }
        } catch (TransformException var18) {
            throw new CommunicationException(var18.getMessageKey(), var18);
        } finally {
            unsetInputData();
        }

        return null;
    }

```

### TransformerFactory分析

用于获取统一（配置的）输入输出报文格式化对象，对象名称由`TransformerTransport`
bean定义配置;

+ bean定义，声明同上

```xml
<!-- xml transformer -->
<bean name="TransformerFactory" class="com.csii.pe.transform.XmlTransformerFactory">
        <param name="path">/config/outbound/csxml/packets</param>
        <param name="debug">${csxml.TransformerFactory.debug}</param>
        <!--<param name="cacheEnable">${csxml.TransformerFactory.cacheEnable}</param>-->
        <param name="cacheEnable">${csxml.TransformerFactory.cacheEnable}</param>
        <map name="parsers">
            <ref name="xmlPacketParser">xmlPacketParser</ref>
        </map>
</bean>
```

+ 被调用 `            Transformer formater = this.transformerFactory.getTransformer(this.formatName);`

    + <param name="formatName">OutboundPacket</param> 在`TransformerTransport` bean定义时候设置，

```java
  public Transformer getTransformer(String id->OutboundPacket) {
    if (!this.initFlag->false) {
      synchronized(this) {
        // private XmlElementFactory elementFactory = new XmlElementFactory();
        this.elementFactory.setApplicationContext(this.applicationContext);
        // <param name="path">/config/outbound/csxml/packets</param>
        if (this.path != null) {
          this.elementFactory.setPathPrefix(this.path);
        }

        // 条件为true不执行
        if (this.mapping != null) {
          this.elementFactory.setMapping(this.mapping);
        }

        // 初始化一次
        this.initFlag = true;
      }
    }

    //获取通用格式化报文变换器对象，相见报文变换器对象创建过程一节
    Transformer element = (Transformer)this.elementFactory.getElement(id);
    return element;
  }
```

+ path被注入的位置一般为报文上送目录，如：
![Text](http://qiniu.jiiiiiin.cn/7pMntj.png)
    基本上每个project都会有类似的一个目录用户存放联机报文，此处为`outbound`即发出报文；
+ 另外pweb上送路由的报文前缀为`fseg`

#### 报文变换器对象创建过程

接上面的`TransformerFactory`在查找通用报文，初始化`Transformer`通用报文变换器对象；

+ 对象类型 `public interface Transformer extends Formatter, Parser `
+ 查找核心代码：

```java
    element = (Element)this.elements.get(id);
    if (element == null) {
      element = (Element)this.getObject(this.pathPrefix ->
      "/config/outbound/csxml/packets" + id->"OutboundPacket)" + ".xml");
    }
```

底层通过`SAXParser` xml解析器找到本机对应文件格式化得到`public class OutboundPacket extends TransformerElement`:

![Text](http://qiniu.jiiiiiin.cn/W9vCU5.png)

![Text](http://qiniu.jiiiiiin.cn/l7ZVYH.png)
+ Element的实现中`OutboundPacket` `pe-transform-guard.jar`对应的是统一格式化报文
+ 另外一个实现`XmlSegment`用来格式化`Body`即作为所有业务具体报文的格式化器实现
    ![Text](http://qiniu.jiiiiiin.cn/POKVvF.png)
    ```java
                } else if (element instanceof Include) {
              Transformer include = (Transformer)((Include)element).getElement(this.includePrefix->"fseg", (Map)data);
              Object includedData = ((Map)data).get(element.getName());
              if (includedData == null) {
                includedData = data;
              }

              // TODO 格式化include即body报文
              byte[] result = (byte[])include.format(includedData, context);
              out.write(result);
            }
    ```
    
    - 在格式化的时候会输出一些调试日志：

    `com.csii.pe.transform.stream.xml.XmlSegment`中输出：

    ```java
    public class XmlSegment extends Segment {
  private String includePrefix = "fseg";

  public void format(OutputStream out, Object data, Map context) throws TransformException {
    try {
      if (this.elementFactory != null && this.elementFactory.getDebug()) {
        System.out.println("XmlSegment.format->" + (Map)data);
      }

    ```
    这里是在格式化伊始就输出上下文或者是手动传递的map，即要填充进报文的数据，注意这个是我们手动传递进去的（不管是在action还是其他环节），所以这里的数据一般来说都应该是待格式化报文所依赖数据的“并集或者说>=报文需要的数据”,如果这里缺少报文声明的数据，那么最终格式化时候对应的节点也将不会生成。
    另外`fseg`就是在这个类中直接写死并打到包中`pe-transform-guard.jar`
    
    ```java
            if (this.elementFactory != null && this.elementFactory.getDebug()) {
          System.out.println("Segment.format->" + element.getName()->"<xmlTag 的节点对应上下文的key值" + "=" + ((Map)data).get(element.getName())-> "key对应的value值");
        }
    ```
   ![Text](http://qiniu.jiiiiiin.cn/fvRMXi.png) 
+ 这个对象将会用来做送上报文的“数据组装”：`Object toSend = formater.format(input, (Map)input);` ，在`TransformTransport `中被调用，传入上下文的dataMap对象；

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Group SYSTEM "packetutf8.dtd">
<Group name="Message" xmlHead="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;">
	<Group name="Head">
		<xmlTag tagName="_TransactionId" >
			<String name="_HostTransactionCode" ></String>
		</xmlTag>

		<xmlTag tagName="IBSTrsTimestamp" >
			<!--Date name="_TransactionTimestamp" pattern="yyyy-MM-dd HH:mm:ss.S" /-->
			<String name="_TransactionTimestamp" ></String>
		</xmlTag>


		<xmlTag ><String name="_BankId" ></String></xmlTag>
		<xmlTag ><String name="_BranchId" ></String></xmlTag>
		<xmlTag ><String name="_DeptId" ></String></xmlTag>
		
		<xmlTag ><String name="_CifNo" ></String></xmlTag> 
		<xmlTag ><String name="_UserId" ></String></xmlTag>
		
		<xmlTag tagName="_LoginType" > <!-- 登录类型 -->
			<String name="LoginType" ></String>
		</xmlTag>
		

	</Group>
	<Group name="Body">
		<include keyName="_HostTransactionCode"></include>
	</Group>
</Group>
```

类型：

```properties
Message=java.util.HashMap
Head=com.csii.pe.transform.stream.xml.Merge2ParentMap
Body=com.csii.pe.transform.stream.xml.Merge2ParentMap
List=java.util.ArrayList
Map=java.util.HashMap
Record=java.util.HashMap

UserAcList=java.util.ArrayList
```


+ 格式化过程，从上面的待格式化报文来看，分为两段`Head/Body`
+ Head就使用上下文中设置的通用数据进行填充如：

```xml
_TransactionId:联机交易码 -> context.setData(Constants.HOST_TRANSACTION_CODE,
"pynrcb.CifSynInfoAndMsgQry");  -> String HOST_TRANSACTION_CODE =
"_HostTransactionCode"; -> 

		<xmlTag tagName="_TransactionId" >
			<String name="_HostTransactionCode" ></String>
		</xmlTag>

```

最终得到的效：
![Text](http://qiniu.jiiiiiin.cn/TBPtqm.png)

+ 如果一个`xmlTag`没有声明`tagName`则使用子节点`<String name="`
  name属性声明的值为生成报文对应节点的节点名称，同时该name属性值同样作为生成报文时候该节点在上下文dataMap中取值的key;

    使用场景，如节点名称和`dataMap`中的`key`不对应时使用；

+ `include`节点（放在`Group name="Body"`中）用来“引用”对应`dataMap`中`keyName`的具体交易报文

+ 关键是这里的Body，被这行代码查找`Transformer body = (Transformer)this.include.getElement(this.getFormatPrefix()->"/config/outbound/csxml/packets", (Map)data);`

也就是通过action或resolver中定义的联机交易来查找实际发送的报文，如：`fsegttpquery.PettyNoPwd.xml`

+ ❓但是这里没有找到在哪里应该是加上了`fseg`这个前缀，不过实际上又是通过`ElementFactory`和通用报文同样的方式找到这个业务报文并对其进行填充

+ 如果`xmlTag`对应在上下文中没有数据（这里都是指上下文的`dataMap`中），则最终`formater.format`得到的格式化报文***不会包含该节点***

+ `xmlTag`
  为`List`的节点，将为生成一个列表，列表对应上下文中的key使用一个子节点`idxField
  name="KEY"` `name`属性来声明
+ 列表中还可以包含`Map`，而`Map`使用`<xmlTag
  tagName="Map">`来声明，举个例子，比如要上送登陆用户绑定账户列表：

  ```xml
  	<xmlTag tagName="List" >
	    <idxField name="UserAcList">
			<xmlTag tagName="Map">
				<bean>
				 	<xmlTag tagName="AcNo" ><String name="id"></String></xmlTag>
				 	<xmlTag tagName="AcType" ><String name="bankAcType"></String></xmlTag>
				 	<xmlTag tagName="AcPermit" ><String name="permission"></String></xmlTag>
				 	<xmlTag tagName="BankAcLevel" ><String name="bankAcLevel" defaultValue="1"></String></xmlTag> 
				</bean>
			</xmlTag>
		</idxField>
	</xmlTag>
  ```
  另外提一点，这里的`UserAcList`是在`CSHeadFormatter`中统一设置；

  另外一个`Map`节点，在声明时候，`<xmlTag
  tagName="Map">`其下第一个子节点需要是一个`<bean>`，在这个节点之下在声明字典中各个字段；

### 格式化报文时候的关键日志




### CSHeadFormatter分析

非重点

可以在交易报文从xml模版进行填充之前（`Object toSend = formater.format(input, (Map)input);`），追加一些参数到上下文dataMap中。

+ 被`TransformerTransport"`调用: `input = this.headFormatter.format(input, (Map)input);`
+ bean声明：
```xml
	<bean name="CSHeadFormatter" class="com.csii.ibs.common.CSHeadFormatter">
		<ref name="cachedBankRuleAttribute">.CachedBankRuleAttribute</ref>
		<ref name="pinSecurityModule">pinSecurityModule</ref>
	</bean>
```
+ 一个自定义的类:
![Text](http://qiniu.jiiiiiin.cn/AKHCu4.png)

+ format 接口主要设置：

    - 如果用户登陆（上下文中获取）则设置用户账号列表/登陆类型/用户id

    ```java
    		if(user!=null)
		{
			dataMap.put(Dict.USERACLIST, user.getAccounts());


			dataMap.put(Dict.LOGINTYPE, user.getLoginType());
			dataMap.put(Constants.USER_ID, user.getUserId());
    ```
    
    - 加密账户交易密码送核心

    ```java
    		if(dataMap.containsKey(Dict.TRSPASSWORD)){
			if(dataMap.get(Dict.TRSPASSWORD) != null && !"".equals(dataMap.get(Dict.TRSPASSWORD))){
				String trsPassword = (String)dataMap.get(Dict.TRSPASSWORD);
				String ibsPassword = "";
				if(trsPassword != null)
					ibsPassword = pinSecurityModule.pinEncrypt(trsPassword);  
			
				dataMap.put(Dict.TRSPASSWORD, ibsPassword);
			}
		}
    ```
    
    题外记录：

    ```java
    	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		PinSecurityModule des = new PinSecurityModule(); 
		String str = new String("88888888");
		String miW = des.pinEncrypt(str);
		System.out.println("密文:["+miW+"]");
        String mingW = des.pinDecrypt(miW);
		System.out.println("明文:["+mingW+"]");
		
		System.out.println("****"+des.pinDecrypt("33BCD5317DA718D2"));
		
	}
    ```
    
## TCPR001.SimpleXMLTcpTransport分析

+ 被TransformerTransport调用：`Object result = this.transport.submit(toSend);`

+ 配置：

```properties
#Communication Server
csxml.TransformerTransport.transport=TCPR001.SimpleXMLTcpTransport
csxml.TransformerTransport.debug=true
# TODO 联机（发送到路由）的TransformerTransport 记录报文源文件的地方
csxml.TransformerTransport.dumpPath=/Users/jiiiiiin/tmp/log/ebank/pweb
```

+ 继承层次

```java
package com.csii.pe.service.comm;

import com.csii.pe.service.Service;

public interface Transport extends Service {
  Object submit(Object var1) throws CommunicationException;
}
```

- public class SocketBean implements SocketFactoryProviderAware 

用于创建 socket来和router或者类似TCP服务进行联机；

`private Socket createSocket1() throws IOException `

`socket.connect(new InetSocketAddress(this.host, this.port), this.connectedTimeout);`

+ AbstractTcpTransport

![Text](http://qiniu.jiiiiiin.cn/Fi4Mr8.png)

实际发送报文数据；

```java
  public final Object submit(Object sndBuffer) throws CommunicationException {
    if (this.isKeepAlive()) {
      return this.submitForKeepAlive(sndBuffer);
    } else {
      try {
        Socket socket = this.createSocket();

        Object var5;
        try {
          socket.getOutputStream().write((byte[])sndBuffer);
          socket.getOutputStream().flush();
          if (this.shutDownOutput) {
            socket.shutdownOutput();
          }

          // 得到一个byte数据流响应对象
          Object result = this.readStream(socket.getInputStream());
          var5 = result;
```

## xmlPacketParser 分析

*非重点*

解析响应（路由）字节流，直接转换成Map；


```xml
	<bean name="xmlPacketParser" class="com.csii.pe.transform.stream.xml.XmlStreamParser">
			<param name="debug">${csxml.xmlPacketParser.debug}</param>
			<param name="tagClassMapping">/config/outbound/csxml/packets/xmltagmapping.properties</param>
			<param name="tagAliasMapping">/config/outbound/csxml/packets/xmlaliasmapping.properties</param>
	</bean>
```

+ 被`com.csii.ibs.common.TransformTransport`调用`object = parser.parse(in, (Map)input);`

+ 继承结构`public abstract class TransformerElement extends AbstractElement
  implements Transformer`

  `public class XmlStreamParser extends TransformerElement implements ApplicationContextAware `

+ 读取 xml 节点映射成java对应类型的自定义设置：`			<param name="tagClassMapping">/config/outbound/csxml/packets/xmltagmapping.properties</param>
`

+  通过xml解析器解析返回的结果报文，如果需要涉及到xml解析或者节点的变动才需要调整或者去深究这部分解析过程，关键的解析代码是在对应的handler自定义实现中完成；

+ 直接将联机**（路由）返回的xml反转成map，对应格式类似：

TODO


