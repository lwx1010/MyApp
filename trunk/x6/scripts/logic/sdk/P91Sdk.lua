---
-- 91平台逻辑
-- @module logic.sdk.P91Sdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local pcall = pcall
local tonumber = tonumber
local CCLuaLog = CCLuaLog
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "logic.sdk.P91Sdk"
module(moduleName)

---
-- 账号
-- @field [parent=#logic.sdk.P91Sdk] #string _uin
-- 
local _uin = nil

---
-- 会话id
-- @field [parent=#logic.sdk.P91Sdk] #string _sessionId
-- 
local _sessionId = nil

---
-- 初始化平台
-- @function [parent=#logic.sdk.P91Sdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local className = "P91Sdk"
	local methodName = "init"
	local args = {callback=_callback}

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
	return true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.P91Sdk] openLoginView
-- 
function openLoginView( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("P91Sdk", "showLogin", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 切换账号
-- @function [parent=#logic.sdk.P91Sdk] switchAccount
-- 
function switchAccount( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("P91Sdk", "switchAccount", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.sdk.P91Sdk] openSdkLogin
-- 
function openSdkLogin( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("P91Sdk", "showLogin", nil)
end

---
-- 打开sdk工具栏
-- @function [parent=#logic.sdk.P91Sdk] openSdkBar
-- @param #number pos 位置
-- 
function openSdkBar( pos )
	local className = "P91Sdk"
	local methodName = "showToolbar"
	local args = {pos=pos}

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
end

---
-- 显示暂停页
-- @function [parent=#logic.sdk.P91Sdk] showPausePage
-- 
function showPausePage( )
	local className = "P91Sdk"
	local methodName = "showPause"

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, nil)
end


---
-- 发送登录协议
-- @function [parent=#logic.sdk.P91Sdk] sendLoginProto
-- 
function sendLoginProto()
	if not _uin or not _sessionId then
		return
	end
	
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {}
	pbObj.token = "1"
	pbObj.account_id = _uin
	pbObj.corpid = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	pbObj.serverid = tonumber(CONFIG[ConfigParams.SERVER_ID])
	pbObj.extdata = "sessionid=".._sessionId
	GameNet.send("C2s_ptduijie_login", pbObj)
end

---
-- pp回调
-- @function [parent=#logic.sdk.P91Sdk] _callback
-- @param #string type 回调类型
-- @param #string retStr 回调结果
-- 
function _callback(type, retStr)
	printf(type.." "..retStr)
	
	if type=="login" then
		if retStr=="success" then
			local luaoc = require("framework.client.luaoc")
			local ret, uin = luaoc.callStaticMethod("P91Sdk", "getUin", nil)
			local ret, sessionId = luaoc.callStaticMethod("P91Sdk", "getSessionId", nil)
			if not uin or not sessionId then
				local Alert = require("view.notify.Alert")
				Alert.show({text=tr("登录失败：账号或者会话错误")}, {{text=tr("确定")}})
				return
			end
			
			openSdkBar(0)
			
			_uin = uin
			_sessionId = sessionId
			
			local LocalConfig = require("utils.LocalConfig")
			local UserConfigs = require("model.const.UserConfigs")
		
			local curAcct = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
			if( not curAcct or uin~=curAcct ) then
				LocalConfig.loadUserConfig(uin)
			end
			
			local ret, userName = luaoc.callStaticMethod("P91Sdk", "getNickName", nil)
			
			-- 选服
			local SelectServerView = require("view.login.SelectServerView")
			SelectServerView.createInstance():openUi(uin, "", sessionId, userName)
			return
		end
		
		-- 错误
		local hasLogined = _uin~=nil
		_uin = nil
		_sessionId = nil
		
		-- 注销了
		if hasLogined then
			local LoginLogic = require("logic.LoginLogic")
			LoginLogic.restartApp(false)
			return
		end
		
		local error = tonumber(retStr)
		-- 用户点击了取消
		if error==-12 then
			return
		end
		
		local string = require("string")
		local msg = string.format(tr("登录失败，错误码为：%d"), error)
		
		local Alert = require("view.notify.Alert")
		Alert.show({text=msg}, {{text=tr("确定")}})
		return
	end
	
	if type=="session" then
		_uin = nil
		_sessionId = nil
		local device = require("framework.client.device")
		device.showAlert("", tr("网络会话失效，请检查网络"), {tr("确定")}, function(event)
			local LoginLogic = require("logic.LoginLogic")
			LoginLogic.restartApp(false)
		end)
		return
	end
	
	if type=="leave" then
		return
	end
	
	if type=="pause" then
		return
	end
	
	if type=="pay" then
		return
	end
end


---
-- 返回货币名字
-- @function [parent=#logic.sdk.P91Sdk] getCurrencyName
-- @return #string 货币名字
-- 
function getCurrencyName()
	return tr("91豆")
end

---
-- 返回货币类型
-- @function [parent=#logic.sdk.P91Sdk] getCurrencyType
-- @return #string 支付账号
-- 
function getCurrencyType()
	return "91"
end

---
-- 返回汇率类型
-- @function [parent=#logic.sdk.P91Sdk] getRateType
-- @return #string 汇率类型
-- 
function getRateType()
	return "91"
end

---
-- 返回支付账号
-- @function [parent=#logic.sdk.P91Sdk] getPayAccount
-- @return #string 支付账号
-- 
function getPayAccount()
	return _uin
end

---
-- 调用sdk的支付接口
-- @function [parent=#logic.sdk.P91Sdk] payBySdk
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @param #string sn 订单号
-- 
function payBySdk(rmb, yuanBao, sn)
	local ConfigParams = require("model.const.ConfigParams")
	local serverId = CONFIG[ConfigParams.SERVER_ID]
	
	local className = "P91Sdk"
	local methodName = "pay"
	local args = {}
	args["sn"] = sn
	args["desc"] = ""..serverId
	args["price"] = rmb
	args["billTitle"] = yuanBao..tr("元宝")
	args["amount"] = 1

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
end