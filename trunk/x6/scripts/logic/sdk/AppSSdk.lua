---
-- 苹果应用商店逻辑
-- @module logic.sdk.AppSSdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local tonumber = tonumber
local PLATFORM_NAME = PLATFORM_NAME
local pairs = pairs

local moduleName = "logic.sdk.AppSSdk"
module(moduleName)

---
-- rmb -> code 表
-- @field [parent=#logic.sdk.AppSSdk] #table _rmbToCodeTb
-- 
local _rmbToCodeTb =
{
	["120"] = "com.millionhero.wsdx.apps.yb120",
	["250"] = "com.millionhero.wsdx.apps.yb250",
	["400"] = "com.millionhero.wsdx.apps.yb400",
	["680"] = "com.millionhero.wsdx.apps.yb680",
	["980"] = "com.millionhero.wsdx.apps.yb980",
	["1980"] = "com.millionhero.wsdx.apps.yb1980",
	["3280"] = "com.millionhero.wsdx.apps.yb3280",
	["6480"] = "com.millionhero.wsdx.apps.yb6480"
}

---
-- 是否初始化支付
-- @field [parent=#logic.sdk.AppSSdk] #boolean _initPay
-- 
local _initPay = false

---
-- 业务表 id -> trans 
-- @field [parent=#logic.sdk.AppSSdk] #table _transTb
-- 
local _transTb = {}

---
-- 初始化平台
-- @function [parent=#logic.sdk.AppSSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.setUseMHSdk(true)
	return true
end

---
-- 初始化支付
-- @function [parent=#logic.sdk.AppSSdk] initPay
-- 
function initPay( )
	if _initPay then return end
	
	local Store = require("framework.client.api.Store")
	Store.init(_transactionCallback)
	
	local ids = {}
	for k, v in pairs(_rmbToCodeTb) do
		ids[#ids+1] = v
	end
	Store.loadProducts(ids, _productCallback)
	
	_initPay = true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.AppSSdk] openLoginView
-- 
function openLoginView( )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.AppSSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {}
	pbObj.token = User.token
	pbObj.account_id = User.acct
	pbObj.corpid = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	pbObj.serverid = tonumber(CONFIG[ConfigParams.SERVER_ID])
	pbObj.extdata = "refer="..PLATFORM_NAME
	GameNet.send("C2s_ptduijie_login", pbObj)
end

---
-- 产品回调
-- @function [parent=#logic.sdk.AppSSdk] _productCallback
-- @param #table event 回调结果
-- 
function _productCallback(event)
	if event.errorCode or event.errorString then
		printf("app store产品下载失败：%s %d", event.errorString, event.errorCode)
		return
	end
	
	if event.products then
		printf("showing valid products", #event.products)
	    for i=1, #event.products do
	        printf(event.products[i].title)              -- string.
	        printf(event.products[i].description)        -- string.
	        printf(event.products[i].price)              -- number.
	        printf(event.products[i].localizedPrice)     -- string.
	        printf(event.products[i].productIdentifier)  -- string.
	    end
    end
	
	if event.invalidProductsId then
	    printf("showing invalidProducts", #event.invalidProductsId)
	    for i=1, #event.invalidProductsId do
	        printf(event.invalidProductsId[i])
	    end
	end
end

---
-- 业务回调
-- @function [parent=#logic.sdk.AppSSdk] _transactionCallback
-- @param #table event 回调结果
-- 
function _transactionCallback(event)
	local os = require("os")
	
	local transaction = event.transaction
    if transaction.state == "purchased" then
        printf("Transaction succuessful!")
        printf("productId", transaction.productId)
        printf("quantity", transaction.quantity)
        printf("transactionIdentifier", transaction.transactionIdentifier)
        printf("date", os.date("%Y-%m-%d %H:%M:%S", transaction.date))
        printf("receipt", transaction.receipt)
        
        -- 记录下来
        _transTb[transaction.transactionIdentifier] = transaction
        
        -- 将id和收据发送给后台
        --
    elseif transaction.state == "restored" then
        printf("Transaction restored (from previous session)")
        printf("productId", transaction.productId)
        printf("receipt", transaction.receipt)
        printf("transactionIdentifier", transaction.identifier)
        printf("date", transaction.date)
        printf("originalReceipt", transaction.originalReceipt)
        printf("originalTransactionIdentifier", transaction.originalIdentifier)
        printf("originalDate", transaction.originalDate)
    elseif transaction.state == "failed" then
        printf("Transaction failed")
        printf("errorCode", transaction.errorCode)
        printf("errorString", transaction.errorString)
    else
        printf("unknown event")
    end

    -- Once we are done with a transaction, call this to tell the store
    -- we are done with the transaction.
    -- If you are providing downloadable content, wait to call this until
    -- after the download completes.
    --framework.client.api.Store.finishTransaction(transaction)
end

---
-- 打开支付界面
-- @function [parent=#logic.sdk.AppSSdk] openPayView
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @return #boolean 是否成功执行
-- 
function openPayView(rmb, yuanBao)
	local Store = require("framework.client.api.Store")
 	if not Store.canMakePurchases() then
 		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("支付功能被禁用，请手动开启支付功能.")}, {{text=tr("确定")}})
		return
    end
    
	local code = _rmbToCodeTb[yuanBao..""]
	if not code then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("找不到产品编码.")}, {{text=tr("确定")}})
		return
	end

	Store.purchase(code)
end

---
-- 服务器支付完毕回调
-- @function [parent=#logic.sdk.AppSSdk] onServerPayEnd
-- @param #string orderId 订单ID
-- 
function onServerPayEnd(orderId)
	local trans = _transTb[orderId]
	if not trans then
		printf("找不到业务对象："..orderId)
		return
	end
	
	_transTb[orderId] = nil
	
	local Store = require("framework.client.api.Store")
	Store.finishTransaction(trans)
end