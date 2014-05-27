---
-- 主要用于调试战斗逻辑，输出到txt文件里头
-- @module view.fight.FightDebug
--

local io = io
local os = os
local string = string
local require = require

local moduleName = "view.fight.FightDebug"
module(moduleName)

---
-- 打开文件的句柄
-- @field [parent = #view.fight.FightDebug] #FILE _fightDebugFile
-- 
local _fightDebugFile

---
-- 在输入数据中加入时间
-- @field [parent = #view.fight.FightDebug] #bool _isAddDate
-- 
local _isAddDate = true

---
-- 往txt里面写入数据
-- @function [parent = #view.fight.FightDebug] writeData
-- @param #string data 字符串数据
-- 
function writeData(data)
	local device = require("framework.client.device")
	if device.platform == "windows" then
		_fightDebugFile = io.open("FightDebug.txt","a")
	elseif device.platform == "android" then
		_fightDebugFile = io.open(device.writablePath.."FightDebug.txt","a")
	end
	
	if device.platform=="windows" or device.platform == "android" then
		if _isAddDate == true then
			local time = os.date()
			data = time.."  "..data
			
			_isAddDate = false
		end
		
		if string.find(data, "\n") ~= nil then
			_isAddDate = true
		end
		
		_fightDebugFile:write(data)
		_fightDebugFile:close()
	end
end


---
-- 清空文件数据
-- @function [parent = #view.fight.FightDebug] clearData
-- 
function clearData()
	local device = require("framework.client.device")
	if device.platform == "windows" then
		_fightDebugFile = io.open("FightDebug.txt","w")
		_fightDebugFile:close()
	elseif device.platform == "android" then
		_fightDebugFile = io.open(device.writablePath.."FightDebug.txt","w")
		_fightDebugFile:close() 
	end
end









