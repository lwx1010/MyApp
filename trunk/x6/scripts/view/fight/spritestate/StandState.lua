---
-- 站立状态 
-- @module view.fight.spritestate.StandState
--

local require = require
local CCLuaLog = CCLuaLog
local printf = printf
local tr = tr
local xpcall = xpcall

local dump = dump

local moduleName = "view.fight.spritestate.StandState"
module(moduleName)

---
-- 状态逻辑执行
-- @function [parent = #view.fight.spritestate.StandState] onStandState
-- @param #table param
-- 
function onStandState(param)
	if not param then
		return 
	end
	
	local tableUtil = require("utils.TableUtil")
	--local isTableEmpty = tableUtil.tableIsEmpty(param)
	--dump(param)
	--if param.getNextActor == true then
	--printf("getNextActor == true")
	local fightCommon = require("view.fight.FightCommon")
	local attack = param.attackTable[1]
	local transition = require("framework.client.transition")
	local addSpeedCoefficient = require("view.fight.FightCommon").getAddSpeedCoefficient()
	
	--一轮攻击结束 背景恢复
	if attack.skillType >= 2 and attack.skillType <= 4 then
		local scene = require("view.fight.FightScene").getFightScene()
		if scene.blackMask ~= nil then
			if scene.blackMask.fadeHandler ~= nil then
				transition.fadeOut(scene.blackMask, 
					{
						time = 0.2/addSpeedCoefficient,
						onComplete = function()
							scene.blackMask.fadeHandler = nil
						end
					}
				)
			end
		end
	end
	
	fightCommon.setSpriteStandAction(attack)
	
	local fightSameTargetTl = require("model.FightData").FightSameTargetTl
	tableUtil.removeFromArr(fightSameTargetTl, attack)
	dump(fightSameTargetTl)
	if tableUtil.tableIsEmpty(fightSameTargetTl) == true then
		fightCommon.getNextActorData()
	end
	--end
end




