---
-- 选服逻辑
-- @module logic.SelectServerLogic
-- 

local require = require
local printf = printf
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local tr = tr
local pcall = pcall
local type = type
local pairs = pairs
local CONFIG = CONFIG
local tonumber = tonumber
local next = next
local CHANNEL_ID = CHANNEL_ID
local ipairs = ipairs

local moduleName = "logic.SelectServerLogic"
module(moduleName)

---
-- windows选服开关(true为开，false为关，默认为false)
-- @field [parent=#logic.SelectServerLogic] #boolean WINDOS_SELECTSERVER_SWITCH
-- 
WINDOS_SELECTSERVER_SWITCH = false

---
-- windows下使用的平台ID,默认为1000(外网)
-- @field [parent=#logic.SelectServerLogic] #number PLAT_ID
-- 
PLAT_ID = 1000

---
-- windows下使用的接口地址
-- @field [parent=#logic.SelectServerLogic] #string ADDRESS
-- 
ADDRESS = "https://admin.mob.millionhero.com"

---
-- 服务器列表(server_name,server_ip)DataSet
-- @field [parent=#logic.SelectServerLogic] #DataSet serverList
-- 
serverList = nil

---
-- 是否已请求服务器列表
-- @field [parent=#logic.SelectServerLogic] #boolean isRequestServerList
-- 
isRequestServerList = false

---
-- 默认服务器名字
-- @field [[parent=#logic.SelectServerLogic] #string defaultServerName
-- 
defaultServerName = nil

---
-- 默认服务器ip
-- @field [parent=#logic.SelectServerLogic] #string defaultServerIP
--
defaultServerIP = nil

---
-- 默认服务器id
-- @field [parent=#logic.SelectServerLogic] #number defaultServerID
--
defaultServerID = nil

---
-- 默认服务器port
-- @field [parent=#logic.SelectServerLogic] #number defaultServerPort
-- 
defaultServerPort = nil 

---
-- 默认服务器区id
-- @field [parent=#logic.SelectServerLogic] #number defaultServerAreaID
-- 
defaultServerAreaID = nil 

---
-- 新服务器名字
-- @field [[parent=#logic.SelectServerLogic] #string newServerName
-- 
newServerName = nil

---
-- 新服务器id
-- @field [[parent=#logic.SelectServerLogic] #number newServerID
--
newServerID = nil

---
-- 新服务器ip
-- @field [parent=#logic.SelectServerLogic] #string newServerIP
--
newServerIP = nil

---
-- 默认服务器port
-- @field [parent=#logic.SelectServerLogic] #number newServerPort
-- 
newServerPort = nil

---
-- 默认服务器区id
-- @field [parent=#logic.SelectServerLogic] #number newServerAreaID
-- 
newServerAreaID = nil

---
-- 服务器状态
-- @field [parent=#logic.SelectServerLogic] #number defaultServerState
-- 
defaultServerState = nil

---
-- 服务器状态
-- @field [parent=#logic.SelectServerLogic] #number newServerState
-- 
newServerState = nil

---
-- 服务器提示
-- @field [parent=#logic.SelectServerLogic] #number defaultServerTip
-- 
defaultServerTip = nil

---
-- 服务器提示
-- @field [parent=#logic.SelectServerLogic] #number newServerTip
-- 
newServerTip = nil


---
-- 默认游戏编码
-- @field [parent=#logic.SelectServerLogic] #string _GAME
-- 
local _GAME = "wsdx"

---
-- 默认平台编号
-- @field [parent=#logic.SelectServerLogic] #number _plat
-- 
local _plat = nil

---
-- 默认地址
-- @field [parne=#logic.SelectServerLogic] #string _address
-- 
local _address = nil

---
-- 是否已获取服务器列表
-- @field [parent=#logic.SelectServerLogic] #boolean hasGetServerList
-- 
hasGetServerList = false

---
-- 请求服务器回调函数
-- @function [parent=#logic.SelectServerLogic] #function _callBack
-- 
local _callBack = nil

---
-- 初始化
-- @function [parent=#logic.SelectServerLogic] _init
-- 
function _init()
	local ConfigParams = require("model.const.ConfigParams")
	_address = CONFIG[ConfigParams.SERVERLIST_WEB]
	_plat = CONFIG[ConfigParams.PLATFORM_ID]
	
	local device = require("framework.client.device")
	if (device.platform == "windows") and (WINDOS_SELECTSERVER_SWITCH) and (_address == nil or _plat == nil) then
		_address, _plat = ADDRESS, PLAT_ID
		CONFIG[ConfigParams.PLATFORM_ID] = PLAT_ID
	end
end

_init()

---
-- 向服务器请求服务器列表
-- @function [parent=#logic.SelectServerLogic] getServer
-- @param #function callBack 回调函数
-- 
function getServer(callBack)
	_callBack = callBack
	hasGetServerList = false
	
	local str = ""
	if not _address then
		str = str .. "_address is nil"
	end
	
	if not _plat then
		str = str .. "_plat is nil"
	end
	
	if not _address or not _plat then
		local Alert = require("view.notify.Alert")
		Alert.show({text=str}, {{text=tr("确定")}})
		return
	end
	
	local os = require("os")
	local uri = "/api/area" .. "/plat/" .. _plat .. "/GAME/" .. _GAME
	local ts = os.time()
--	local ts = 1234567890
	local key = "mhis1,000kheros"
	
	local sign = CCCrypto:MD5Lua(uri..ts..key, false)

	local url = _address .. uri .. "?ts=" .. ts .. "&sign=" .. sign
--	local url = "https://admin.mob.millionhero.com/api/area/plat/1000/GAME/wsdx?ts=1234567890&sign=00b74f0d8918e69c6db6a736ecc78b13"
--	printf("url: %s", url)
	local request = CCHTTPRequest:createWithUrlLua(_getServerListCallBack, url, nil)

	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("创建获取服务器列表线程失败.请检查网络")}, {{text=tr("确定")}})
		return
	end
	
	request:setTimeout(60)
	request:start()	
end

---
-- 向服务器请求服务器列表回调函数
-- @function [parent=#logic.SelectServerLogic] _getServerListCallBack
-- @param #table event 服务器列表事件
-- 
function _getServerListCallBack(event)
	if event.name=="progress" then
--		printf(tr("获取服务器列表中") .. "progress")
		return
	end
	
	printf("enter serverList callback")
	
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if event.name~="completed" or errCode~=0 or responseCode~=200 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("获取服务器列表失败.请检查网络."..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
		return
	end
	
	local jsonStr = request:getResponseString()
	if jsonStr==nil or #jsonStr<=0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("选服列表内容为空.请检查网络")}, {{text=tr("确定")}})
		return
	end
	
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, jsonStr)
    if not status or not result then
    	local Alert = require("view.notify.Alert")
		Alert.show({text=tr("选服数据解析失败.请检查网络."..jsonStr)}, {{text=tr("确定")}})
		return
    end
    
    if next(result) == nil then
--    	local Alert = require("view.notify.Alert")
--   	Alert.show({text=tr("选服数据为空.请退出或重启游戏.")}, {{text=tr("确定")}})
		local DataSet = require("utils.DataSet")
   	 	serverList = DataSet.new()
   	 	
   	 	local ConfigParams = require("model.const.ConfigParams") 	 	
   	 	local item = {
    				server_name = tr("审核测试区"),
    				server_ip = CONFIG[ConfigParams.SERVER_IP],
    				server_port = CONFIG[ConfigParams.SERVER_PORT],
    				server_id = CONFIG[ConfigParams.SERVER_ID],
    				server_area_id = CONFIG[ConfigParams.AREA_ID],
    				server_state = 2
    			}
--    		printf("server_name: %s", item.server_name)
--   		printf("server_ip: %s", item.server_ip)
    	serverList:addItem(item)
    	hasGetServerList = true
   		return
    end
    
    local Channels = require("model.const.Channels")
	local isTest = (CHANNEL_ID == Channels.AUDIT)
    
    local tempArr = {}
    for k, _ in pairs(result) do
    	if type(result[k]) ~= "table" or type(result[k]["domain"]) ~= "table" 
   		or result[k]["name"] == nil or result[k]["domain"]["server"] == nil 
   		or type(result[k]["port"]) ~= "table" or result[k]["port"]["engine"] == nil then
   			local Alert = require("view.notify.Alert")
   			Alert.show({text=tr("选服数据错误.请检查网络.")}, {{text=tr("确定")}})
    		return
    	end
    	if result[k]["test"] == nil then
    		result[k]["test"] = false
    	end
    	if  isTest == result[k]["test"] then
    		local extra = result[k]["extra"]
    		if extra then
    			for _, v in pairs(extra) do
    				extra = v
    			end
    		end
    		
    		local item = {
    			server_name = result[k]["name"],
    			server_ip = result[k]["domain"]["server"],
    			server_port = result[k]["port"]["engine"],
    			server_id = tonumber(result[k]["id"]),
    			server_area_id = k,
    			server_state = result[k]["state"],
    			server_tip = extra,
    			index = tonumber(result[k]["index"]) or 0
    		}
    		
    		-- 把obj id也记录下来
    		if result[k]["_id"] and result[k]["_id"]["$id"] then
    			item["obj_id"] = result[k]["_id"]["$id"]
    		end
    		
--    		printf("obj_id: %s", item.obj_id)
--    		printf("server_area_id: %s", item.server_area_id)
--    		printf("server_name: %s", item.server_name)
--   			printf("server_ip: %s", item.server_ip)
    		--serverList:addItem(item)
    		tempArr[#tempArr+1] = item
    	end
    end
    
    -- 排序
    local table = require("table")
    table.sort(tempArr, function(a,b) return a.index>b.index end)
    
    local DataSet = require("utils.DataSet")
   	serverList = DataSet.new()
    serverList:setArray(tempArr)
    	
    if serverList:getLength() == 0 then
    	local ConfigParams = require("model.const.ConfigParams") 	 	
   	 	local item = {
    		server_name = tr("审核测试区"),
    		server_ip = CONFIG[ConfigParams.SERVER_IP],
    		server_port = CONFIG[ConfigParams.SERVER_PORT],
    		server_id = CONFIG[ConfigParams.SERVER_ID],
    		server_area_id = CONFIG[ConfigParams.AREA_ID],
    		server_state = 2
    	}
--    	printf("server_name: %s", item.server_name)
--   	printf("server_ip: %s", item.server_ip)
    	serverList:addItem(item)
    end
    
--    local SelectServerData = require("model.SelectServerData") 
--    SelectServerData.compareServerList(serverList, jsonStr)
    
    if _callBack then
    	_callBack()
    	_callBack = nil
   	end
   	
   	hasGetServerList = true
   	local Events = require("model.event.Events")
   	local EventCenter = require("utils.EventCenter")
	EventCenter:dispatchEvent({name = Events.SELECTEDSERVERLIST_UPDATE.name})
end

---
-- 从本地读最近登录的服务器
-- @function [parent=#logic.SelectServerLogic] readLastServerFromConfig
-- @param self
-- @return #boolean
-- 
function readLastServerFromConfig()
--	printf("enter readLastServerFromConfig")
	local LocalConfig = require("utils.LocalConfig")
	local UserConfigs = require("model.const.UserConfigs")
	
	newServerName = nil
	newServerIP = nil
	newServerPort = nil
	newServerID = nil
	newServerAreaID = nil
	
	local localTest = LocalConfig.getValue(false, UserConfigs.IS_TEST)
	local isLocalTest
	if localTest == 1 then
		isLocalTest = true
	else
		isLocalTest = false
	end
	local Channels = require("model.const.Channels")
	local isTest = (CHANNEL_ID == Channels.AUDIT)
	if isLocalTest == isTest then
		defaultServerName = LocalConfig.getValue(false, UserConfigs.SERVER_NAME)
		defaultServerIP = LocalConfig.getValue(false, UserConfigs.SERVER_IP)
		defaultServerPort = LocalConfig.getValue(false, UserConfigs.SERVER_PORT)
		defaultServerID = LocalConfig.getValue(false, UserConfigs.SERVER_ID)
		defaultServerAreaID = LocalConfig.getValue(false, UserConfigs.AREA_ID)
		
		local isWhite = LocalConfig.getValue(false, UserConfigs.IS_WHITE)
	else
		return false
	end
--	printf(defaultServerName)
--	printf(defaultServerIP)
--return false
	if defaultServerName == nil or defaultServerIP == nil or defaultServerID == nil then
		return false
	else
		return true
	end
end

---
-- 将用户配置写到本地文件
-- @function [parent=#logic.SelectServerLogic] saveLastServerToConfig
-- @param self
-- 
function saveLastServerToConfig()
--	printf("enter saveLastServerToConfig")
	local LocalConfig = require("utils.LocalConfig")
	local ConfigParams = require("model.const.ConfigParams")
	local Channels = require("model.const.Channels")
	
	local isTest
	if (CHANNEL_ID == Channels.AUDIT) then
		isTest = 1
	else
		isTest = 0 
	end
	
	if newServerName and newServerIP then
		LocalConfig.setValue(false, ConfigParams.SERVER_NAME, newServerName)
		LocalConfig.setValue(false, ConfigParams.SERVER_IP, newServerIP)
		LocalConfig.setValue(false, ConfigParams.SERVER_PORT, newServerPort)
		LocalConfig.setValue(false, ConfigParams.SERVER_ID, newServerID)
		LocalConfig.setValue(false, ConfigParams.AREA_ID, newServerAreaID)
	else
		LocalConfig.setValue(false, ConfigParams.SERVER_NAME, defaultServerName)
		LocalConfig.setValue(false, ConfigParams.SERVER_IP, defaultServerIP)
		LocalConfig.setValue(false, ConfigParams.SERVER_PORT, defaultServerPort)
		LocalConfig.setValue(false, ConfigParams.SERVER_ID, defaultServerID)
		LocalConfig.setValue(false, ConfigParams.AREA_ID, defaultServerAreaID)
	end
	LocalConfig.setValue(false, ConfigParams.IS_TEST, isTest)
end