---
-- 每日奖励模块
-- @module model.RewardData
-- 

local moduleName = "model.RewardData"
module(moduleName)

---
-- 能否领取VIP奖励
-- @field [parent=#model.RewardData] #boolean vipReward 
-- 
vipReward = false

---
-- 能否领取体力奖励
-- @field [parent=#model.RewardData] #boolean tiLiReward 
-- 
tiLiReward = false

---
-- VIP奖励信息
-- @field [parent=#RewardData] #table vipRewardInfo 
-- 
vipRewardInfo = nil

---
-- 运营活动气泡开始隐藏时间
-- @field [parent=#RewardData] #number starHideTime
-- 
starHideTime = 0

---
-- 运营活动信息
-- @field [parent=#RewardData] #table activityInfo 
-- 
activityInfo = nil

---
-- 推送活动信息
-- @field [parent=#RewardData] #table pushActInfo 
-- 
pushActInfo = nil
