---
-- pp平台逻辑
-- @module logic.sdk.PPSdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local tonumber = tonumber

local moduleName = "logic.sdk.PPSdk"
module(moduleName)

---
-- 初始化平台
-- @function [parent=#logic.sdk.PPSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.setSupportReconnect(false)
	
	local className = "PPSdk"
	local methodName = "setLuaCallback"
	local args = {callback=_callback}

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
	return true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.PPSdk] openLoginView
-- 
function openLoginView( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("PPSdk", "showLogin", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.sdk.PPSdk] openSdkLogin
-- 
function openSdkLogin( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("PPSdk", "showLogin", nil)
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.PPSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {token=User.token, serverid=tonumber(CONFIG[ConfigParams.SERVER_ID])}
	GameNet.send("C2s_pp_login", pbObj)
end

---
-- pp回调
-- @function [parent=#logic.sdk.PPSdk] _callback
-- @param #string type 回调类型
-- @param #string retStr 回调结果
-- 
function _callback(type, retStr)
	printf(type.." "..retStr)
	
	if type=="login" then
		local luaoc = require("framework.client.luaoc")
		local ret, uid = luaoc.callStaticMethod("PPSdk", "currentUserId", nil)
		if not ret or not uid then
			local Alert = require("view.notify.Alert")
			Alert.show({text=tr("登录失败：用户ID错误")}, {{text=tr("确定")}})
			return
		end
		
		local LocalConfig = require("utils.LocalConfig")
		local UserConfigs = require("model.const.UserConfigs")
	
		local curAcct = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
		if( not curAcct or uid~=curAcct ) then
			LocalConfig.loadUserConfig(uid)
		end
		
		local ret, userName = luaoc.callStaticMethod("PPSdk", "currentUserName", nil)
		
		-- 选服
		local SelectServerView = require("view.login.SelectServerView")
		SelectServerView.createInstance():openUi(uid, "", retStr, userName)
		return
	end
	
	if type=="logoff" then
		local LoginLogic = require("logic.LoginLogic")
		LoginLogic.restartApp(false)
		return
	end
end

---
-- 设置充值开放
-- @function [parent=#logic.sdk.PPSdk] setOpenPay
-- @param #boolean open 是否开放
-- @param #string closeMsg 关闭提示
-- 
function setOpenPay( open, closeMsg )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("PPSdk", "setOpenPay", {isOpen=open and 1 or 0, closeMsg=closeMsg})
end

---
-- 返回货币名字
-- @function [parent=#logic.sdk.PPSdk] getCurrencyName
-- @return #string 货币名字
-- 
function getCurrencyName()
	return tr("PP币")
end

---
-- 返回货币类型
-- @function [parent=#logic.sdk.PPSdk] getCurrencyType
-- @return #string 支付账号
-- 
function getCurrencyType()
	return "PP"
end

---
-- 返回汇率类型
-- @function [parent=#logic.sdk.PPSdk] getRateType
-- @return #string 汇率类型
-- 
function getRateType()
	return "PP"
end

---
-- 返回支付账号
-- @function [parent=#logic.sdk.PPSdk] getPayAccount
-- @return #string 支付账号
-- 
function getPayAccount()
	local luaoc = require("framework.client.luaoc")
	local ret, userName = luaoc.callStaticMethod("PPSdk", "currentUserName", nil)
	return userName
end

---
-- 调用sdk的支付接口
-- @function [parent=#logic.sdk.PPSdk] payBySdk
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @param #string sn 订单号
-- 
function payBySdk(rmb, yuanBao, sn)
	local ConfigParams = require("model.const.ConfigParams")
	local serverId = CONFIG[ConfigParams.SERVER_ID]
	
  	local className = "PPSdk"
	local methodName = "exchangeGoods"
	local args = {}
	args["price"] = rmb
	args["billTitle"] = yuanBao..tr("元宝")
	args["roleId"] = 0
	args["zoneId"] = serverId
	args["billNo"] = sn
	
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
end