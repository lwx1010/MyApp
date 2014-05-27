---
-- 排行榜数据
-- @module model.RankData
--

local require = require
local pairs = pairs
local table = table
local tr = tr
local os = os
local printf = printf

local moduleName = "model.RankData"
module(moduleName)

---
-- 排行榜数据本地缓存
-- @field [parent=#model.RankData] utils.DataSet#DataSet _rankData
-- 
local _rankData = nil

---
-- 排行榜刷新定时器句柄
-- @field [parent=#model.RankData] #scheduler _handle
-- 
local _handle = nil

---
-- 排名本地缓存
-- @field [parent=#model.RankData] #number _rank
-- 
local _rank = nil

---
-- 本地缓存初始化
-- @function [parent=#model.RankData] init
-- 
function init()
	if _rankData then _rankData = nil end 

	local DataSet = require("utils.DataSet")
	_rankData = DataSet.new()
	
	local scheduler = require("framework.client.scheduler")
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_ranklist_info", {place_holder = 1})
	GameNet.send("C2s_ranklist_selfinfo", {place_holder = 1})
	
	if _handle  then scheduler.unscheduleGlobal(_handle) end
	_handle = scheduler.scheduleGlobal(function()
		GameNet.send("C2s_ranklist_info", {place_holder = 1})
		GameNet.send("C2s_ranklist_selfinfo", {place_holder = 1}) 
	end, 30 * 60)
end

---
-- 断线重连初始化
-- @function [parent=#model.RankData] _registerRestartCallBack
-- 
-- 
function _registerRestartCallBack()
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RECONNECT.name, _init, nil)
end

---
-- 构造数据
-- @function [parent=#model.RankData] constructData
-- @param #S2c_ranklist_info pb
-- 
function constructData(pb)
	if not pb.list_info or not pb.fight_time then return end
	
	local list, time= pb.list_info, pb.fight_time
	table.sort(list, function(a, b) return a.rank < b.rank end)
	
	local endTime = time + os.time()
	for k, v in pairs(list) do
		v["fight_time"] = endTime
	end
	
	_rankData:setArray(list)
end

---
-- 获取数据
-- @function [parent=#model.RankData] getData
-- @return #DataSet
--
function getData()
	return _rankData
end

---
-- 构造排名
-- @function [parent=#model.RankData] constructRank
-- @param #S2c_ranklist_selfinfo pb
-- 
function constructRank(pb)
	_rank = pb.rank
end

---
-- 获取排名
-- @function [parent=#model.RankData] getRank
-- @return #number
--
function getRank()
	return _rank
end
--_registerRestartCallBack()