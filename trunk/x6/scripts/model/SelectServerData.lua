---
-- 选服列表数据
-- @module model.SelectServerData
-- 


local require = require
local table = table
local io = io
local EXTERNAL_PATH = EXTERNAL_PATH
local pcall = pcall
local tr = tr
local type = type
local pairs = pairs
local tonumber = tonumber
local CHANNEL_ID = CHANNEL_ID
local printf = printf

local moduleName = "model.SelectServerData" 
module(moduleName)

---
-- 选服列表
-- @field [parent=#model.SelectServerData] utils.DataSet#DataSet serverList 存服务器列表
-- 
serverList = nil

---
-- 是否已向服务器请求
--  @field [parent=#model.SelectServerData] #boolean isRequestServerList
--  
isRequestServerList = false

---
-- 选服列表数据初始化
-- @function [parent=#model.SelectServerData] _init
-- 
function _init()
	readServerListFromCache()
end

---
-- 读缓存选服列表
-- @function [parent=#model.SelectServerData] readServerListFromCache
--
function readServerListFromCache()
	local DataSet = require("utils.DataSet")
   	serverList = DataSet.new()
   	
	local logFile = io.open(EXTERNAL_PATH.."serverlist.txt", "r")
	local jsonStr = nil
    if( logFile ) then
    	jsonStr = logFile:read()
    	logFile:close()
    end
    if not jsonStr then return end
    local cjson = require("cjson")
	local status, result = pcall(cjson.decode, jsonStr)
    if not status or not result then
    	local Alert = require("view.notify.Alert")
		Alert.show({text=tr("缓存选服数据解析失败."..jsonStr)}, {{text=tr("确定")}})
		return
    end
    	
    	local Channels = require("model.const.Channels")
		local isTest = (CHANNEL_ID == Channels.AUDIT)
    	
    	for k, _ in pairs(result) do
    		if type(result[k]) ~= "table" or type(result[k]["domain"]) ~= "table" 
   			or result[k]["name"] == nil or result[k]["domain"]["server"] == nil 
   			or type(result[k]["port"]) ~= "table" or result[k]["port"]["engine"] == nil then
   				local Alert = require("view.notify.Alert")
   				Alert.show({text=tr("缓存选服数据错误.")}, {{text=tr("确定")}})
    			return
    		end
    		
    		if  isTest == result[k]["test"] then
    			local item = {
    				server_name = result[k]["name"],
    				server_ip = result[k]["domain"]["server"],
    				server_port = result[k]["port"]["engine"],
    				server_id = tonumber(result[k]["id"]),
    				server_area_id = k
    			}
--    		printf("server_name: %s", item.server_name)
--   			printf("server_ip: %s", item.server_ip)
    			serverList:addItem(item)
    		end
    	end
end

---
-- 写选服列表到缓存
-- @function [parent=#model.SelectServerData] wirteServerListToCache
-- @param #string newList 新的服务器列表数据
--
function wirteServerListToCache(newList)
	if( #newList<=0 ) then return end
	
    local logFile = io.open(EXTERNAL_PATH.."serverlist.txt", "w")
    if( logFile ) then
    	logFile:write(newList)
    	logFile:close()
    end
end

---
-- 比较选服列表
-- @function [parent=#model.SelectServerData] compareServerList
-- @param #DataSet newList 新的服务器列表数据
-- @param #string newStr 新的服务器列表数据(JSon)
--
function compareServerList(newList, newStr)
	if serverList:getLength() ~= newList:getLength() then
		serverList:setArray(newList:getArray())
		wirteServerListToCache(newStr)
	else
		local arr = serverList:getArray()
		local newArr = newList:getArray()
		for i = 1, #arr do
			if arr[i].server_name ~= newArr[i].server_name or arr[i].server_ip ~= newArr[i].server_ip or
				arr[i].server_port ~= newArr[i].server_port or arr[i].server_id ~= newArr[i].server_id then
				serverList:setArray(newList:getArray())
				wirteServerListToCache(newStr)
				break
			end
		end
	end
	isRequestServerList = true 
end

_init()