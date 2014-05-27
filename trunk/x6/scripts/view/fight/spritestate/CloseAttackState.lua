---
-- 移动到目标身旁 攻击的状态
-- @module view.fight.spritestate.CloseAttackState
--

local require = require
local printf = printf

local dump = dump

local moduleName = "view.fight.spritestate.CloseAttackState"
module(moduleName)

---
-- 连续攻击的延迟时间
-- @field [parent = #view.fight.spritestate.CloseAttackState] #number _SAME_TAR_ATTACK_DELTIME
-- 
local _SAME_TAR_ATTACK_DELTIME = 0.5

---
-- 近战攻击状态
-- @function [parent = #view.fight.spritestate.CloseAttackState] onMoveToCloseAttackState
-- @param #table param
-- 
function onMoveToCloseAttackState(param)
	--dump(param)
	local fightCommon = require("view.fight.FightCommon")
	local fightStateMachine = require("view.fight.FightStateMachine")
	--local fsm = fightStateMachine.getStateMachine()
	local actorTable = param
	--local attack = fightCommon.getCurrAttackSprite()
	local attack = actorTable.attackTable[1]
	--local target = fightCommon.getCurrTargetSprite()
	local target = actorTable.targetTable[1]
	
	local fightScene = require("view.fight.FightScene")
	local isSameTarget = false
	local sameTargetAttacker
	
	isSameTarget, sameTargetAttacker = fightScene.isNextActorSameTarget()
	
	if isSameTarget == true then
		printf("next target is same !!!")
		
		local fightSameTargetTl = require("model.FightData").FightSameTargetTl
		fightSameTargetTl[#fightSameTargetTl + 1] = sameTargetAttacker
		dump(fightSameTargetTl)
		
		printf("attack.hasGetNextActor = true")
		
		sameTargetAttacker:performWithDelay( 
			function ()
				local fightCommon = require("view.fight.FightCommon")
				fightCommon.getNextActorData(0)
				printf(sameTargetAttacker)
				printf(sameTargetAttacker.id.." 连续攻击人物获取了数据")
			end,
			_SAME_TAR_ATTACK_DELTIME
		)
	end
	
	if #target.targetIds == 1 then
		-- 单体攻击
		--printf("单体攻击 测试")
		attack.fsm:doEvent("singleAttackEvt", param)
		
	elseif #target.targetIds > 1 then
		-- 群体攻击
		attack.fsm:doEvent("mulAttackEvt", param)
	end
end




