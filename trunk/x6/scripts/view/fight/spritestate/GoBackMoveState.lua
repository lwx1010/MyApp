---
-- 单体攻击转为移动状态
-- @module view.fight.spritestate.GoBackMoveState
--

local require = require
local printf = printf

local moduleName = "view.fight.spritestate.GoBackMoveState"
module(moduleName)

---
-- 执行状态函数
-- @function [parent = #view.fight.spritestate.GoBackMoveState] onGoBackMoveState
-- @param #table param
--
function onGoBackMoveState(param)
	local transition = require("framework.client.transition")
	local fightCommon = require("view.fight.FightCommon")
	local roundAttack = param.attackTable[1]
	local roundTarget = param.targetTable[1]
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	--local fsm = require("view.fight.FightStateMachine").getStateMachine()
	
	local math = require("math")

	transition.moveTo(roundAttack,
		{
			time = math.abs(roundAttack.x - roundTarget.x)/3333,--0.2,
			x = roundAttack.x,
			y = roundAttack.y,
			onComplete = function()
				if roundAttack then
					--transition.removeAction(_roundAttack.idleForeverAction)
					--doTransition(_sprite, _state.currState, "idle")
					--if isSameTarget == false then
					roundAttack.fsm:doEvent("goBackEvt", param)
					--end
				end
			end
		}
	)
	
	
end



