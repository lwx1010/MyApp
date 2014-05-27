---
-- 累计登录奖励数据模块
-- @module model.BonusLoginData
--

local require = require
local printf = printf
local pairs = pairs
local table = table
local next = next
local tr = tr
local dump = dump


local moduleName = "model.BonusLoginData"
module(moduleName)


--- 
-- 能领取奖励时间信息表
-- @field [parent=#model.BonusLoginData] #table partnerTbl
-- 
daysTbl = nil

---
-- 奖励数据集
-- @field [parent=#model.BonusLoginData] utils.DataSet#DataSet rewardSet
-- 
rewardSet = nil


---
-- 初始化
-- @function [parent=#model.BonusLoginData] _init
-- 
function _init()
	daysTbl = {}
	
	local DataSet = require("utils.DataSet")
	rewardSet = DataSet.new()
end

-- 执行初始化
_init()

---
-- 更新所有同伴
-- @function [parent=#model.BonusLoginData] updateAllReward
-- @field [parent=#model.BonusLoginData] #talbe arr 同伴数组
-- 
function updateAllReward( arr )
	if( not arr ) then return end

	-- 禁用事件
--	rewardSet:enableEvent(false)
	rewardSet:removeAll()
	
	rewardSet:setArray(arr)
end


---
-- 更新奖励领取信息
-- @function [parent=#model.BonusLoginData] updateReward
-- @field [parent=#model.BonusLoginData] #number day 
-- 
function updateReward( day )
	if( not day ) then return end
	
	local rewardArr = rewardSet:getArray()
	local reward, r
	for i=1, #rewardArr do
		r = rewardArr[i]
		if r.day == day then
			reward = r
			break
		end
	end
	
	if not reward then return end
	reward["isget"] = 1
	
	-- 更新列表
	rewardSet:itemUpdated(reward)
end

---
-- 取奖励时间信息表
-- @function [parent=#model.BonusLoginData] getDaysTbl
-- @return #table 
-- 
function getDaysTbl()
	return daysTbl
end

---
-- 设置奖励时间信息表
-- @function [parent=#model.BonusLoginData] setDaysTbl
-- @field [parent=#model.BonusLoginData] #table days 
-- 
function setDaysTbl(days)
	for i=1, #days do
		daysTbl[i] = {}
		daysTbl[i].day = days[i]
		daysTbl[i].receive = false
	end
--	dump(daysTbl)
end

---
-- 设置奖励时间信息表
-- @function [parent=#model.BonusLoginData] setReceiveDay
-- @field [parent=#model.BonusLoginData] #number day
-- 
function setReceiveDay(day)
	local info
	for i=1, #daysTbl do
		info = daysTbl[i]
		if info.day == day then
			info.receive = true
			break
		end
	end
--	dump(daysTbl)
end
