---
-- 平台逻辑
-- @module logic.PlatformLogic
-- 

local require = require
local printf = printf
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME
local CONFIG = CONFIG
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local pcall = pcall
local tonumber = tonumber
local CCLuaLog = CCLuaLog
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "logic.PlatformLogic"
module(moduleName)

---
-- 平台对应的sdk
-- @field [parent=#logic.PlatformLogic] #table _sdk
-- 
local _sdk = nil

--- 
-- 登录警告框
-- @field [parent=#logic.PlatformLogic] view.notify.Alert#Alert _loginAlert
-- 
local _loginAlert

---
-- 是否正在支付中
-- @field [parent=#logic.PlatformLogic] #boolean _isPaying
-- 
local _isPaying = false

---
-- 支付参数
-- @field [parent=#logic.PlatformLogic] #table _payParams
-- 
local _payParams = nil

---
-- 订单号key
-- @field [parent=#logic.PlatformLogic] #string _snKey
-- 
local _snKey = nil

---
-- 是否支持断线重连
-- @field [parent=#logic.PlatformLogic] #boolean _supportReconnect
-- 
local _supportReconnect = true

---
-- 是否使用万将自有用户平台
-- @field [parent=#logic.PlatformLogic] #boolean _useMHSdk
-- 
local _useMHSdk = false

---
-- 初始化平台
-- @function [parent=#logic.PlatformLogic] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	
	local Platforms = require("model.const.Platforms")
	
	if PLATFORM_NAME==nil or PLATFORM_NAME=="" or PLATFORM_NAME==Platforms.BANSHU then
		_sdk = require("logic.sdk.SelfSdk")
	elseif PLATFORM_NAME==Platforms.KINGSOFT then
		_sdk = require("logic.sdk.KingsoftSdk")
	elseif PLATFORM_NAME==Platforms.PP then
		_sdk = require("logic.sdk.PPSdk")
	elseif PLATFORM_NAME==Platforms.P91 then
		_sdk = require("logic.sdk.P91Sdk")
	elseif PLATFORM_NAME==Platforms.MM then
		_sdk = require("logic.sdk.MMSdk")
	elseif PLATFORM_NAME==Platforms.TB then
		_sdk = require("logic.sdk.TBSdk")
	elseif PLATFORM_NAME==Platforms.KY then
		_sdk = require("logic.sdk.KuaiyongSdk")
	elseif PLATFORM_NAME==Platforms.APPS then
		_sdk = require("logic.sdk.AppSSdk")
	end
	
	if not _sdk then
		printf("找不到平台相关的sdk："..PLATFORM_NAME)
		return
	end
	
	if _sdk.initPlatform then
		return _sdk.initPlatform()
	end
end

---
-- 设置是否使用Mhsdk
-- @function [parent=#logic.PlatformLogic] setUseMHSdk
-- @param #boolean val	是否使用
-- 
function setUseMHSdk( val )
	_useMHSdk = val
end

---
-- 是否使用Mhsdk
-- @function [parent=#logic.PlatformLogic] isUseMHSdk
-- @return #boolean 是否使用Mhsdk
-- 
function isUseMHSdk()
	return _useMHSdk
end

---
-- 设置是否支持断线重连
-- @function [parent=#logic.PlatformLogic] setSupportReconnect
-- @param #boolean val	是否支持
-- 
function setSupportReconnect( val )
	_supportReconnect = val
end

---
-- 是否支持断线重连
-- @function [parent=#logic.PlatformLogic] isSupportReconnect
-- @return #boolean 是否支持断线重连
-- 
function isSupportReconnect()
	return _supportReconnect
end

---
-- 初始化支付
-- @function [parent=#logic.PlatformLogic] initPay
-- 
function initPay( )
	local ConfigParams = require("model.const.ConfigParams")
	local corpid = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	
	-- 取订单号keys
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_secret_get", {corp_id=corpid, key="app"})
	
	if _sdk and _sdk.initPay then
		_sdk.initPay()
	end
end

---
-- 打开登录界面
-- @function [parent=#logic.PlatformLogic] openLoginView
-- 
function openLoginView( )
	local device = require("framework.client.device")
	local SelectServerLogic = require("logic.SelectServerLogic")
	
	if (device.platform ~= "windows") or (SelectServerLogic.WINDOS_SELECTSERVER_SWITCH) then
		SelectServerLogic.getServer(nil)
	end
	
	if _sdk and _sdk.openLoginView then
		_sdk.openLoginView()
	end
end

---
-- 切换账号
-- @function [parent=#logic.PlatformLogic] switchAccount
-- 
function switchAccount( )
	if _sdk and _sdk.switchAccount then
		_sdk.switchAccount()
		return
	end
	
	-- 没有切换账号就显示登录界面
	openLoginView()
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.PlatformLogic] openSdkLogin
-- 
function openSdkLogin( )
	if _sdk and _sdk.openSdkLogin then
		_sdk.openSdkLogin()
	end
end

---
-- 打开sdk工具栏
-- @function [parent=#logic.PlatformLogic] openSdkBar
-- @param #number pos 位置
-- 
function openSdkBar( pos )
	if _sdk and _sdk.openSdkBar then
		_sdk.openSdkBar( pos )
	end
end

---
-- 显示暂停页
-- @function [parent=#logic.PlatformLogic] showPausePage
-- 
function showPausePage( )
	if _sdk and _sdk.showPausePage then
		_sdk.showPausePage( )
	end
end

---
-- 发送登录协议
-- @function [parent=#logic.PlatformLogic] sendLoginProto
-- 
function sendLoginProto()
	if _sdk and _sdk.sendLoginProto then
		_sdk.sendLoginProto()
	end
	
	if _loginAlert then
		_loginAlert:hide()
		_loginAlert:release()
		_loginAlert = nil
	end
	
	local Alert = require("view.notify.Alert")
	_loginAlert = Alert.show({text=tr("正在登录服务器中...")})
	_loginAlert:retain()
end

---
-- 隐藏登录警告框
-- @function [parent=#logic.PlatformLogic] hideLoginAlert
-- 
function hideLoginAlert()
	if _loginAlert then
		_loginAlert:hide()
		_loginAlert:release()
		_loginAlert = nil
	end
end

---
-- 设置充值开放
-- @function [parent=#logic.PlatformLogic] setOpenPay
-- @param #boolean open 是否开放
-- @param #string closeMsg 关闭提示
-- 
function setOpenPay( open, closeMsg )
	if _sdk and _sdk.setOpenPay then
		_sdk.setOpenPay(open, closeMsg)
	end
end

---
-- 打开支付界面
-- @function [parent=#logic.PlatformLogic] openPayView
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @return #boolean 是否成功执行
-- 
function openPayView(rmb, yuanBao)
	if _sdk and _sdk.openPayView then
		return _sdk.openPayView(rmb, yuanBao)
	end
	
	if _isPaying then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("已有兑换正在处理中,请稍后.")}, {{text=tr("确定")}})
		return
	end
	
	
	local currencyName = "xx"
	if _sdk and _sdk.getCurrencyName then
		currencyName = _sdk.getCurrencyName()
	end
	
	local currencyUnitName = tr("个")
	if _sdk and _sdk.getCurrencyUnitName then
		currencyUnitName = _sdk.getCurrencyUnitName()
	end
	
	local currencyRate = 1
	if _sdk and _sdk.getCurrencyRate then
		currencyRate = _sdk.getCurrencyRate()
	end

	local string = require("string")
	local msg = string.format(tr("确定使用 %d %s%s兑换 %d 元宝吗？"), rmb * currencyRate, currencyUnitName, currencyName, yuanBao);
	local yesBtn = tr("确定")
	local noBtn = tr("取消")

	local device = require("framework.client.device")
	if device.platform=="android" then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local methodName = "showAlert"
		local args = {"", msg, yesBtn, noBtn, function(btn)
			if btn==yesBtn then
				_pay(rmb, yuanBao)
			end
		end}
		
		local luaj = require("framework.client.luaj")
		luaj.callStaticMethod(className, methodName, args)
		return true
	end
	
	if device.platform=="ios" then
		device.showAlert("", msg, {yesBtn, noBtn}, function(event)
			if event.buttonIndex==1 then
				_pay(rmb, yuanBao)
			end
		end)
		return true
	end
	
	local Alert = require("view.notify.Alert")

	local item1 = {text=yesBtn}
	item1.listener = function( ... )
		_pay(rmb, yuanBao)
	end
	
	local item2 = {text=noBtn}
	Alert.show({text=msg}, {item1,item2})
	
	return true
end


---
-- 兑换元宝
-- @function [parent=#logic.sdk.PPSdk] _pay
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- 
function _pay(rmb, yuanBao)
	if _isPaying then return end
	
	-- 取订单号
	if not _snKey then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("订单key错误")}, {{text=tr("确定")}})
		return
	end
	
	local ConfigParams = require("model.const.ConfigParams")
	local platId = CONFIG[ConfigParams.PLATFORM_ID]
	local areaId = CONFIG[ConfigParams.AREA_ID]
	local payWeb = CONFIG[ConfigParams.PAY_WEB]
	local serverId = CONFIG[ConfigParams.SERVER_ID]
	if not platId or not areaId or not payWeb or not serverId then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("兑换：支付页面等配置参数为空")}, {{text=tr("确定")}})
		return
	end
	
	local userName
	if _sdk and _sdk.getPayAccount then
		userName = _sdk.getPayAccount()
	end

	if not userName then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("兑换：用户名获取失败")}, {{text=tr("确定")}})
		return
	end
	
	local string = require("string")
	userName = string.urlencode(userName) 
	
	local rateType = "PP"
	if _sdk and _sdk.getRateType then
		rateType = _sdk.getRateType()
	end
	
	local currencyRate = 1
	if _sdk and _sdk.getCurrencyRate then
		currencyRate = _sdk.getCurrencyRate()
	end
	
	local money = rmb * currencyRate
	
	local os = require("os")
	local exttblStr = string.urlencode('{"serverid":'..serverId.."}")
	local queryFormat = "exttbl=%s&amount=%d&area=%s&currency=%s&game=wsdx&money=%d&plat=%d&sn=&ts=%d&user=%s"
	local queryStr = string.format(queryFormat, exttblStr, yuanBao, areaId, rateType, money, platId, os.time(), userName)
	
	local signStrFormat = "amount=%d&area=%s&currency=%s&game=wsdx&key=%s&money=%d&plat=%d&sn=&ts=%d&user=%s"
	local signStr = string.format(signStrFormat, yuanBao, areaId, rateType, _snKey and _snKey or "", money, platId, os.time(), userName)
	local sign = CCCrypto:MD5Lua(signStr, false)
	
	-- 取订单号
	local url = payWeb.."/plat/"..platId.."/area/"..areaId.."?"..queryStr.."&sign="..sign
	local request = CCHTTPRequest:createWithUrlLua(_paySnDownloadCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("兑换：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	_payParams = {rmb=rmb, yuanBao=yuanBao}
	--_payParams = {price=rmb, billTitle=""..yuanBao, roleId=0, zoneId=serverId}
	_isPaying = true
	return true
end

--- 
-- 支付sn下载回调
-- @function [parent=#update.update] _paySnDownloadCallback
-- @param #table event 下载事件
-- 
function _paySnDownloadCallback( event )
	if event.name=="progress" then
		return
	end
	
	_isPaying = false
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if event.name~="completed" or errCode~=0 or responseCode~=200 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("订单号获取失败："..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
		return
	end
	
	local jsonStr = request:getResponseString()
	if jsonStr==nil or #jsonStr<=0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("订单号获取失败：订单号为空")}, {{text=tr("确定")}})
		return
	end
	
	printf(jsonStr)
	
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, jsonStr)
    if not status or not result or not result["id"] then
   		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("订单号解析失败："..jsonStr)}, {{text=tr("确定")}})
		return
    end
    
    if not _payParams then
    	local Alert = require("view.notify.Alert")
		Alert.show({text=tr("兑换参数错误")}, {{text=tr("确定")}})
		return
	end
	
	if _sdk and _sdk.payBySdk then
		_sdk.payBySdk(_payParams["rmb"], _payParams["yuanBao"], result["id"])
	end
    
	if SUPPORT_TALKINGDATA then
		local type = ""
		if _sdk and _sdk.getCurrencyType then
			type = _sdk.getCurrencyType()
		end
	
		local args = {}
		args["orderId"] = result["id"];
		args["iapId"] = _payParams["yuanBao"];
		args["amount"] = _payParams["rmb"];
		args["type"] = type;
		args["visualAmount"] = _payParams["rmb"];
		args["payType"] = type;
		
		local luaoc = require("framework.client.luaoc")
		luaoc.callStaticMethod("TalkingDataSdk", "chargeBegin", args)
		
		--luaoc.callStaticMethod("TalkingDataSdk", "chargeEnd", {orderId=result["id"]})
	end
	
	_payParams = nil
end


---
-- 设置订单号key
-- @function [parent=#logic.PlatformLogic] setSnKey
-- @param #string key key
-- 
function setSnKey(key)
	printf("sn key:"..key)
	_snKey = key
end

---
-- 设置支付账号
-- @function [parent=#logic.PlatformLogic] setPayAccount
-- @param #string uin 支付账号
-- 
function setPayAccount(uin)
	if _sdk and _sdk.setPayAccount then
		_sdk.setPayAccount(uin)
		return
	end
end

---
-- 设置guid
-- @function [parent=#logic.PlatformLogic] setGuid
-- @param #string guid
-- 
function setGuid(guid)
	if _sdk and _sdk.setGuid then
		_sdk.setGuid(guid)
		return
	end
end

---
-- 服务器支付完毕回调
-- @function [parent=#logic.PlatformLogic] onServerPayEnd
-- @param #string orderId 订单ID
-- 
function onServerPayEnd(orderId)
	if not orderId or #orderId<=0 then 
		return
	end

	if SUPPORT_TALKINGDATA then
		local luaoc = require("framework.client.luaoc")
		luaoc.callStaticMethod("TalkingDataSdk", "chargeEnd", {orderId=orderId})
	end
	
	if _sdk and _sdk.onServerPayEnd then
		_sdk.onServerPayEnd(orderId)
	end
end