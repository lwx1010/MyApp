---
-- 在线奖励逻辑
-- @module logic.OnlineRewardLogic
-- 

local require = require
local os = os

local printf = printf

local moduleName = "logic.OnlineRewardLogic"
module(moduleName)

---
-- 记录服务端发过来的间隔时间
-- @field [parent = #logic.OnlineRewardLogic] #number _rewardTime
--
local _rewardTime = 0

---
-- 获取间隔时间的当前时间
-- @field [parent = #logic.OnlineRewardLogic] #number _getRewardOSTime
-- 
local _getRewardOSTime = os.time()

---
-- 设置当前登录在线奖励心跳时间
-- @field [parent = #logic.OnlineRewardLogic] #number _currBeatTime
-- 
local _currBeatTime = nil

---
-- 判断是否收到服务端在线奖励的更新协议
-- @field [parent = #logic.OnlineRewardLogic] #number _isReceveServUpdate
-- 
local _isReceveServUpdate = false

---
-- 设置当前
-- @function [parent = #logic.OnlineRewardLogic] setCurrBeatTime
-- 
function setCurrBeatTime(beatTime)
	_currBeatTime = beatTime
end

---
-- 设置是否已经收到在线更新协议信息
-- @function [parent = #logic.OnlineRewardLogic] setReceveServUpdate
-- @param #bool receve
-- 
function setReceveServUpdate(receve)
	_isReceveServUpdate = receve
end

---
-- 设置间隔时间
-- @function [parent = #logic.OnlineRewardLogic] setOnlineRewardTime
-- @param #number time
--
function setOnlineRewardTime(time)
	if time then
		_rewardTime = time
	else
		_currBeatTime = nil
	end
	_getRewardOSTime = os.time()
end

---
-- 更新在线奖励时间
-- @function [parent = #logic.OnlineRewardLogic] updateRewardTime
-- @param #number time
-- 
function updateRewardTime(time)
	_rewardTime = time
end

---
-- 设置下次的连续在线奖励时间
-- @function [parent = #logic.OnlineRewardLogic] setNext
-- 
function setNext()
	setOnlineRewardTime()
end

---
-- 获取在线奖励时间
-- @function [parent = #logic.OnlineRewardLogic] getOnlineRewardTime
--
function getOnlineRewardTime()
	return _rewardTime
end

---
-- 计算是否可以领取奖励时间
-- @function [parent = #logic.OnlineRewardLogic] isCanGetOnlineReward
-- @return #bool
-- 
function isCanGetOnlineReward()
	if _isReceveServUpdate == false then
		return false
	end

	local nextRewardTime = 0
	if _currBeatTime then
		nextRewardTime = _currBeatTime
	else
		nextRewardTime = _rewardTime
	end
	
	local deltaTime = os.difftime(os.time(), _getRewardOSTime)

	if deltaTime > nextRewardTime + 1 then
		return true
	else
		return false
	end
end



