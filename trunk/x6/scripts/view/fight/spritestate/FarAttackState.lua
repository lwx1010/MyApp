---
-- 远程攻击，BUFF状态
-- @module view.fight.spritestate.FarAttackState
--

local require = require

local moduleName = "view.fight.spritestate.FarAttackState"
module(moduleName)

---
-- 记录传入参数
-- @field [parent = #view.fight.spritestate.FarAttackState] #table _saveInParam 
-- 
local _saveInParam = nil

---
-- 状态执行函数
-- @function [parent = #view.fight.spritestate.FarAttackState] onFarAttackState
-- @param #table param 
function onFarAttackState(param)
	-- 记录轮数
	param.round = 1
	param.maxRound = #param.attackTable
	
	_saveInParam = param
	
	local fightCommon = require("view.fight.FightCommon")
	local actorTable = param
	--local attack = fightCommon.getCurrAttackSprite()
	local attack = actorTable.attackTable[1]
	--local target = fightCommon.getCurrTargetSprite()
	local target = actorTable.targetTable[1]
	
	_attackTarget(attack, target, attack)
end

---
-- 攻击动作
-- @function [parent = #view.fight.spritestate.FarAttackState] _attackTarget
-- @param #CCSpirte attack
-- @param #CCSprite target
-- @param #CCSprite roundAttack 当前回合的出手者
-- 
function _attackTarget(attack, target, roundAttack)
	local fightCommon = require("view.fight.FightCommon")

	--local roundAttack = fightCommon.getCurrAttackSprite()
	
	local paramData = _saveInParam
	
	local round = paramData.round
	local maxRound = paramData.maxRound
	 	
	local spriteTable = _saveInParam
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	local effectTime = fightCommon.getEffectTime()
	--local fsm = require("view.fight.FightStateMachine").getStateMachine() 
	
	-- 转换状态延迟时间
	local delayTime = 0.2

	-- 攻击音效
	if fightCommon.isNormalAttack(attack.skillID) == false then
		if attack.attackSound and attack.attackSound>0 then
			local audio = require("framework.client.audio")
			audio.playEffect("sound/"..attack.attackSound..".mp3")
		end
	end
	
	local function attackComplete()
		--改变状态为站立态
		fightCommon.setSpriteStandAction(attack)
		
		--继续播放下个战斗
		if round and maxRound then
			if round < maxRound then
				round = paramData.round + 1
				paramData.round = round
				local attack = spriteTable.attackTable[round]
				local target = spriteTable.targetTable[round]
				fightCommon.setRoundAttackType(spriteTable.attackType[round])
				--CCLuaLog("反击")
				_attackTarget(attack, target, roundAttack)
			else
				--CCLuaLog(tr("终止回合..."))
				return
			end
		end
	end
	
	fightCommon.setSpriteAttackAction(attack, attackComplete)
	fightCommon.afterAttackShow(attack, target, spriteTable.attackType[round])
	
	
	
	--显示完特效需要执行的逻辑
	if maxRound <= 1 then
		roundAttack:performWithDelay(
			function ()				
				if round == maxRound then 
					attack.fsm:doEvent("attackFinishEvt", paramData)
				end
			end,
			effectTime/addSpeedCoefficient/2 + delayTime
		)
	else
		-- 受到反击，则特效播完才回去
		local isDie = target.isDie
		roundAttack:performWithDelay(
			function ()				
				if round == maxRound then  --判断反击
					if maxRound > 1 then
						if target == roundAttack then
							if isDie ~= true then
								roundAttack.fsm:doEvent("attackFinishEvt", paramData)
							else
								--如果这回合目标将要死亡，就不用回去了
								roundAttack.fsm:doEvent("deadEvt", paramData)
							end
						end
					else
						roundAttack.fsm:doEvent("attackFinishEvt", paramData)
					end
				end
			end,
			effectTime/addSpeedCoefficient/2 + delayTime
		)
	end
end