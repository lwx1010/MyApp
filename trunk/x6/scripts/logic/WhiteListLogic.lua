---
-- 白名单逻辑
-- @module logic.WhiteListLogic
-- 

local require = require
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local next = next
local tr = tr
local pcall = pcall
local type = type
local pairs = pairs
local CONFIG = CONFIG
local printf = printf

local moduleName = "logic.WhiteListLogic"
module(moduleName)

---
-- 默认游戏编码
-- @field [parent=#logic.WhiteListLogic] #string INTERFACE_ADDRESS
-- 
local INTERFACE_ADDRESS = "https://admin.mob.millionhero.com"

---
-- 是否白名单用户
-- @field [parent=#logic.WhiteListLogic] #bool isWhiteListAccount
-- 
isWhiteListAccount = false

---
-- 是否请求已返回
-- @field [parent=#logic.WhiteListLogic] #bool isRequestReturn
-- 
isRequestReturn = false

---
-- 请求服务器回调函数
-- @function [parent=#logic.WhiteListLogic] #function _callBack
-- 
local _callBack = nil

---
-- 请求服务器回调函数
-- @function [parent=#logic.WhiteListLogic] #scheduler _handle
-- 
local _handle = nil

---
-- 向服务器请求账号是否白名单
-- @function [parent=#logic.WhiteListLogic] isInWhiteList
-- @param #string account 账号
-- @param #number plat 平台
-- @param #function callback 回调函数
-- 
function isInWhiteList(account, plat, callback)	
	isWhiteListAccount = false
	isRequestReturn = false
	_callBack = callback
--	account = "mikespook"
	
	local os = require("os")
	local uri = "/api/whitelist" .. "/account/" .. account
	local ts = os.time()
	local key = "mhis1,000kheros"
	
	local sign = CCCrypto:MD5Lua(uri.. ts .. key, false)

	local url = INTERFACE_ADDRESS .. uri .. "?" .. "ts=" .. ts.. "&plat=" .. plat .. "&sign=" .. sign
	local request = CCHTTPRequest:createWithUrlLua(_isInWhiteListCallBack, url, nil)
--	printf(url)

	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("创建判断账号是否白名单账号线程失败.请检查网络")}, {{text=tr("确定")}})
		return
	end
	
	request:setTimeout(10)
	request:start()
	
	local scheduler = require("framework.client.scheduler")
	_handle = scheduler.performWithDelayGlobal(function(...)
		isWhiteListAccount = false
		isRequestReturn = true
		_handle = nil
		
		local Events = require("model.event.Events")
   		local EventCenter = require("utils.EventCenter")
		EventCenter:dispatchEvent({name = Events.WHITELIST_UPDATE.name})
	end, 10)
end

---
-- 向服务器请求账号是否白名单账号回调函数
-- @function [parent=#logic.WhiteListLogic] _isInWhiteListCallBack
-- @param #table event 白名单事件
-- 
function _isInWhiteListCallBack(event)
	if event.name=="progress" then
--		printf(tr("获取白名单数据中") .. "progress")
		return
	end
	
	if _handle then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(_handle)
		_handle = nil
	end
	
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if event.name~="completed" or errCode~=0 or responseCode~=200 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("获取白名单失败.请检查网络."..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
		return
	end
	
	local jsonStr = request:getResponseString()
	
	if jsonStr == "null" then
		isWhiteListAccount = false
		isRequestReturn = true
		
		if _callBack then
    		_callBack()
    		_callBack = nil
   		end
   		
   		local Events = require("model.event.Events")
   		local EventCenter = require("utils.EventCenter")
		EventCenter:dispatchEvent({name = Events.WHITELIST_UPDATE.name})
   		return
	end
	
	if jsonStr==nil or #jsonStr<=0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("白名单数据为空.请检查网络")}, {{text=tr("确定")}})
		return
	end
	
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, jsonStr)
	
    if not status or not result then
    	local Alert = require("view.notify.Alert")
		Alert.show({text=tr("白名单数据解析失败.请检查网络."..jsonStr)}, {{text=tr("确定")}})
		return
    end
    
    -- 不是白名单
    if next(result) == nil then
    	local Alert = require("view.notify.Alert")
   		Alert.show({text=tr("白名单数据为空.请退出或重启游戏.")}, {{text=tr("确定")}})
    end
    	
    for k, _ in pairs(result) do
    	if result["account"] == nil  then
   				local Alert = require("view.notify.Alert")
   				Alert.show({text=tr("白名单数据错误.请检查网络.")}, {{text=tr("确定")}})
    			return
    	end	
  		isWhiteListAccount = true
		isRequestReturn = true
		break
    end
    
    if _callBack then
    	_callBack()
    	_callBack = nil
   	end
   	
   	local Events = require("model.event.Events")
   	local EventCenter = require("utils.EventCenter")
	EventCenter:dispatchEvent({name = Events.WHITELIST_UPDATE.name})
end