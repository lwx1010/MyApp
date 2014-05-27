---
-- 单体攻击
-- @module view.fight.spritestate.SingleAttackState
--

local require = require

local printf = printf
local dump = dump

local ccc3 = ccc3

local moduleName = "view.fight.spritestate.SingleAttackState"
module(moduleName)

---
-- 保存输入参数
-- @field [parent = #view.fight.spritestate.SingleAttackState] _saveInParam
-- 
local _saveInParam = nil

---
-- 单体攻击状态
-- @function [parent = #view.fight.spritestate.SingleAttackState] onSingleAttackState
-- @param #table param
--
function onSingleAttackState(param)
	printf("进入单体攻击")
	
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
-- @function [parent = #view.fight.spritestate.SingleAttackState] _attackTarget
-- @param #CCSpirte attack
-- @param #CCSprite target
-- @param #CCSprite roundAttack 当前回合攻击者
-- 
function _attackTarget(attack, target, roundAttack)
	printf(attack)
	printf(roundAttack)
	local fightCommon = require("view.fight.FightCommon")
	
	--local roundAttack = fightCommon.getCurrAttackSprite()
--	local round = fightCommon.getCurrRound()
--	local maxRound = #_saveInParam.attackTable
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
				printf("反击")
				_attackTarget(attack, target, roundAttack)
				
				local skillXls = require("xls.SkillEffectXls").data
				local ui = require("framework.client.ui")
				local text = ui.newTTFLabelWithShadow(
					{
						text = skillXls[attack.skillID].Name,
						color = ccc3(0, 255, 0),
						size = 28,
						align = ui.TEXT_ALIGN_CENTER,
						x = attack:getContentSize().width/2,
						y = attack:getContentSize().height/2 + 30
					}
				)
				
				attack:addChild(text)		
				fightCommon.tipEffect(text)
			else
				--CCLuaLog(tr("终止回合..."))
				return
			end
		end
	end
	
	fightCommon.setSpriteAttackAction(attack, attackComplete)
	fightCommon.afterAttackShow(attack, target, spriteTable.attackType[round])
	
	--显示完特效需要执行的逻辑
	--local paramData = _saveInParam
	if maxRound <= 1 then
		attack:performWithDelay(
			function ()				
				if round == maxRound then  
					printf("攻击完成 转入下个状态")
					printf(attack)
					attack.fsm:doEvent("attackFinishEvt", paramData)
					printf("转入状态完成")
				end
			end,
			effectTime/addSpeedCoefficient/2 + delayTime
		)
	else
		-- 受到反击，则特效播完才回去
		local isDie = target.isDie
		attack:performWithDelay(
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










