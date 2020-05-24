---
title: "Error Prompt Noteds"
date: 2020-03-30T17:49:44+08:00
draft: true
---

<!-- vim-markdown-toc GFM -->

* [通用错误](#通用错误)

<!-- vim-markdown-toc -->

## 通用错误

+ `can't find host transaction code for: `

```java
public void prepareCommonFields(Context context, Map map) {
		map.put("_TransName", context.getTransactionId());
		String tmpTrsCode = (String) map.get("_HostTransactionCode");
		if (tmpTrsCode == null) {
			if (this.trsCode != null) {
				map.put("_HostTransactionCode", this.trsCode);
			} else if (this.trsCodeResolver != null) {
				String tmpStr = this.trsCodeResolver.resolve(context);
				if (tmpStr != null) {
					map.put("_HostTransactionCode", tmpStr);
				} else if (this.log.isDebugEnabled()) {
					this.log.debug("can't find host transaction code for: " + context.getTransactionId());
				}
			} else if (this.log.isDebugEnabled()) {
				this.log.debug(
						"can't resolve host transaction code, pls make sure you have set Constants.HOST_TRANSACTION_CODE in  map or set a valid trsCodeResolver or set trsCode properties for this class");
			}
		}

```

在action发送submit（即一般在两阶段交易，发送核心请求的时候），如果在预处理方法中，没有发现核心的交易码就报这个错；

+ `"system.placeholders_error"`

```java
public class TwoPhaseTrsTemplate extends AbstractTrsWorkflow {
	private boolean transactionEnabled = false;
	private List sensitiveFields;

	public void execute(Context context) throws PeException {
      Action preAction = this.getAction("preAction", context);
      Action aftAction = this.getAction("aftAction", context);
      Action action = this.getAction("action", context);
      if (action instanceof PlaceholderAction) {
         throw new PeException("system.placeholders_error", new Object[]{this.getClass().getName(), context.getTransactionId()});
      } else if (!(action instanceof Submitable)) {
         throw new PeException("system.placeholders_error", new Object[]{this.getClass().getName(), context.getTransactionId(), action.getClass().getName()});
      } else {

```
没有按模版要求注入对应类型实现的action导致；

