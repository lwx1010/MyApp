---
-- mm平台逻辑
-- @module logic.sdk.MMSdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local tonumber = tonumber
local CCLuaJavaBridge = CCLuaJavaBridge
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "logic.sdk.MMSdk"
module(moduleName)

---
-- rmb -> paycode 表
-- @field [parent=#logic.sdk.MMSdk] #table _rmbToPayCodeTb
-- 
local _rmbToPayCodeTb =
{
	["50"] = "30000815856701",
	["100"] = "30000815856702",
	["150"] = "30000815856703",
	["200"] = "30000815856704",
	["250"] = "30000815856705",
	["300"] = "30000815856706"
}

---
-- 初始化平台
-- @function [parent=#logic.sdk.MMSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.setUseMHSdk(true)
	
	local className = "sdk.MMSdk"
	local args = {"300008158567", "7FE439BC9D4B9B1E", _callback}
	local sig = "(Ljava/lang/String;Ljava/lang/String;I)I"
	local ret, realRet = CCLuaJavaBridge.callStaticMethod(className, "init", args, sig)
	
	if not ret or not realRet or realRet<=0 then return end
	
	return true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.MMSdk] openLoginView
-- 
function openLoginView( )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.sdk.MMSdk] openSdkLogin
-- 
--function openSdkLogin( )
--	local luaoc = require("framework.client.luaoc")
--	luaoc.callStaticMethod("MMSdk", "showLogin", nil)
--end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.MMSdk] sendLoginProto
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
-- pp回调
-- @function [parent=#logic.sdk.MMSdk] _callback
-- @param #string retStr 回调结果
-- 
function _callback(retStr)
	printf(retStr)
end

---
-- 设置充值开放
-- @function [parent=#logic.sdk.MMSdk] setOpenPay
-- @param #boolean open 是否开放
-- @param #string closeMsg 关闭提示
-- 
--function setOpenPay( open, closeMsg )
--	local luaoc = require("framework.client.luaoc")
--	luaoc.callStaticMethod("MMSdk", "setOpenPay", {isOpen=open and 1 or 0, closeMsg=closeMsg})
--end

---
-- 返回货币名字
-- @function [parent=#logic.sdk.MMSdk] getCurrencyName
-- @return #string 货币名字
-- 
function getCurrencyName()
	return tr("话费")
end

---
-- 返回货币单位
-- @function [parent=#logic.sdk.MMSdk] getCurrencyUnitName
-- @return #string 货币单位
-- 
function getCurrencyUnitName()
	return tr("元")
end

---
-- 返回货币类型
-- @function [parent=#logic.sdk.MMSdk] getCurrencyType
-- @return #string 支付账号
-- 
function getCurrencyType()
	return "MM"
end

---
-- 返回支付账号
-- @function [parent=#logic.sdk.MMSdk] getPayAccount
-- @return #string 支付账号
-- 
function getPayAccount()
	local MHSdk = require("logic.sdk.MHSdk")
	return MHSdk.getAccount()
end

---
-- 调用sdk的支付接口
-- @function [parent=#logic.sdk.MMSdk] payBySdk
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @param #string sn 订单号
-- 
function payBySdk(rmb, yuanBao, sn)
	local payCode = _rmbToPayCodeTb[yuanBao..""]
	if not payCode then
		printf("paycode error: "..yuanBao)
		return
	end
	
	local MHSdk = require("logic.sdk.MHSdk")
	local string = require("string")
	
	local ext = "id="..string.urlencode(MHSdk.getAccount())
	ext = ext..";orderid="..string.urlencode(sn)
	
	local className = "sdk.MMSdk"
	local args = {payCode, 1, ext}
	local sig = "(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;"
	local ret, realRet = CCLuaJavaBridge.callStaticMethod(className, "order", args, sig)
end