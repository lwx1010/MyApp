---
-- 商城物品信息
-- @module model.FightData
-- 

local require = require

local moduleName = "model.FightData"
module(moduleName)

---
-- 战斗剧情喊话表
-- @field [parent = #model.FightData] #table FightPlotMsgTl
--
FightPlotMsgTl = {}

---
-- 战斗剧情喊话信息剩余条数
-- @field [parent = #model.FightData] #number FightLeftPlotMsgNum
--
FightLeftPlotMsgNum = 0

---
-- 战斗剧情喊话当前显示的条数
-- @field [parent = #model.FightData] #number FightCurrPlotNum
-- 
FightCurrPlotNum = 1

---
-- 保存背包侠客的最大值
-- @field [parent = #model.FightData] #number BagPartnerMaxNum
--  
BagPartnerMaxNum = 0

---
-- 保存背包装备的最大值
-- @field [parent = #model.FightData] #number BagEquitMaxNum
-- 
BagEquitMaxNum = 0

---
-- 保存背包武学的最大值
-- @field [parent = #model.FightData] #number BagMartialMaxNum
-- 
BagMartialMaxNum = 0

---
-- 保存侠客碎片的最大值
-- @field [parent = #model.FightData] #number PartnerChipMaxNum
-- 
PartnerChipMaxNum = 0

---
-- 保存装备碎片的最大值
-- @field [parent = #model.FightData] #number EquitChipMaxNum
-- 
EquitChipMaxNum = 0

---
-- 保存武功碎片的最大值
-- @field [parent = #model.FightData] #number MartialChipMaxNum
-- 
MartialChipMaxNum = 0

---
-- 这次战斗的回合数
-- @field [parent = #model.FightData] #number FightBout
-- 
FightBout = 0

---
-- 战斗ID ，神行用
-- @field [parent = #model.FightData] #number FightId
-- 
FightId = 0

---
-- 记录未完成一起攻击的人物
-- @field [parent = #model.FightData] #table FightSameTargetTl
-- 
FightSameTargetTl = {}


---
-- 相同目标的第一个攻击者
-- @field [parent = #model.FightData] #bool FightSameTarMainAttackFinish 
-- 
FightSameTarMainAttackFinish = false

---
-- 重置战斗数据
-- @function [parent = #model.FightData] resetFightData
-- 
function resetFightData()
	FightPlotMsgTl = {}
	FightLeftPlotMsgNum = 0
	FightCurrPlotNum = 1
	FightBout = 0
	FightId = 0
	FightSameTargetTl = {}
	FightSameTarMainAttackFinish = false
end













