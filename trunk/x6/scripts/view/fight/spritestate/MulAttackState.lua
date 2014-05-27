---
-- 近战群攻
-- @module view.fight.spritestate.MulAttackState
-- 

local require = require

local printf = printf
local dump = dump

local moduleName = "view.fight.spritestate.MulAttackState"
module(moduleName)

---
-- 保存状态输入参数
-- @field [parent = #view.fight.spritestate.MulAttackState] _saveInParam
-- 
local _saveInParam = nil

---
-- 保存多人攻击的目标
-- @field [parent = #view.fight.spritestate.MulAttackState] _saveMulTargets
-- 
local _saveMulTargets = nil

---
-- 近战群攻状态
-- @function [parent = #view.fight.spritestate.MulAttackState] onMulAttackState
-- @param #table param
-- 
function onMulAttackState(param)
	-- 记录轮数
	param.round = 1
	param.maxRound = #param.attackTable
	--dump(param)
	_saveInParam = param
	
	local display = require("framework.client.display")
	local transition = require("framework.client.transition")
	local fightScene = require("view.fight.FightScene")
	

	local fightCommon = require("view.fight.FightCommon")
	local attack = param.attackTable[1]
	local target = param.targetTable[1]
	local addFightSpeed = fightCommon.getAddFightSpeed()
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	
	local offsetX
	if target:isFlipX() == true then
		offsetX = -100
	else
		offsetX = 100
	end
	
	-- 开启分身状态
	--放入自己
	attack.sepSpriteTable = {}
	attack.sepSpriteTable[#attack.sepSpriteTable + 1] = attack
	local targetIds = target.targetIds
	_saveMulTargets = targetIds
	--延迟一段时间，再展开分身
	attack:performWithDelay(
		function()
			for i = 1, #targetIds do
				--分身到各个目标前
				local onetarget = targetIds[i]
				printf("新建分身前")
				printf(onetarget)
				printf(target)
				if onetarget ~= target then
					printf("新建分身啦")
					
					--新建一个分身
					local sepSprite = display.newSprite()
					sepSprite:setDisplayFrame(attack:displayFrame())
					sepSprite:setFlipX(attack:isFlipX())
					sepSprite:setPosition(attack:getPosition())
					sepSprite:setOpacity(150)
					fightScene.getFightScene():addChild(sepSprite)
					--sepSprite:runAction(attack.idleForeverAction)
					
					attack.sepSpriteTable[#attack.sepSpriteTable + 1] = sepSprite
					transition.moveTo(sepSprite,
					{
						time = 0.15/addSpeedCoefficient,
						x = onetarget.x + offsetX,
						y = onetarget.y - 1,
						easing = "CCEaseOut"
					})
				end
				
				--延迟一段时间，转入攻击模式
				if i == #targetIds then
					attack:performWithDelay(
						function()
							_attackTarget(attack, target, attack)
						end,
						0.2/addSpeedCoefficient
					)
				end
			end
		end,
		0.2/addSpeedCoefficient
	)
end

---
-- 攻击动作
-- @function [parent = #view.fight.spritestate.MulAttackState] _attackTarget
-- @param #CCSpirte attack
-- @param #CCSprite target
-- @param #CCSprite roundAttack 当前回合攻击者
-- 
function _attackTarget(attack, target, roundAttack)
	local fightCommon = require("view.fight.FightCommon")
	
	local transition = require("framework.client.transition")
	local spriteAction = require("utils.SpriteAction") 
	
	-- 临时保存战斗状态输入参数
	local paramData = _saveInParam
	local targetIds = _saveMulTargets
	
	local spriteTable = _saveInParam
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	local attackActionTime = fightCommon.getAttackActionTime()
	--local roundAttack = fightCommon.getCurrAttackSprite()
	local round = paramData.round
	local maxRound = paramData.maxRound
	 	
	--local spriteTable = fightCommon.getSpriteTable()
	--local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
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
	
	-- 攻击动作完成回调
	local function attackComplete()
		--删除sepSpriteTable
		if attack.sepSpriteTable then
			for i = 1, #attack.sepSpriteTable do
				if attack.sepSpriteTable[i] ~= attack then
					attack.sepSpriteTable[i]:stopAllActions()
					attack.sepSpriteTable[i]:removeFromParentAndCleanup(true)
				end
			end
			attack.sepSpriteTable = {}
		end
		
		--继续播放下个战斗
		if round and maxRound then
			if round < maxRound then
				round = paramData.round + 1
				paramData.round = round
				fightCommon.setSpriteStandAction(roundAttack)
				local attack = spriteTable.attackTable[round]
				local target = spriteTable.targetTable[round]
				fightCommon.setRoundAttackType(spriteTable.attackType[round])
				--CCLuaLog("反击")
				_attackTarget(attack, target, roundAttack)
			else 
				return
			end
		end
	end
	
	--播放分身动作
	if attack.sepSpriteTable then
		for i = 1, #attack.sepSpriteTable do
			
			local sepSpriteAttack = attack.sepSpriteTable[i]
			if sepSpriteAttack.idleForeverAction then
				sepSpriteAttack:removeAction(sepSpriteAttack.idleForeverAction)
				sepSpriteAttack.idleForeverAction = nil
			end
			sepSpriteAttack.attackOnceAction = spriteAction.spriteRunOnceAction(sepSpriteAttack, attack.imageID.."/attack1/7/1000%d.png", 0, 4,
				function ()
					
					
					if attack.sepSpriteTable == nil then
						return
					end
					
					if i == #attack.sepSpriteTable then
						attackComplete()
					end
				end,
				attackActionTime/addSpeedCoefficient
			)
		end
	end
	
	fightCommon.afterAttackShow(attack, target, spriteTable.attackType[round], targetIds)
	--显示完特效需要执行的逻辑
	if maxRound <= 1 then
		attack:performWithDelay(
			function ()				
				if round == maxRound then  
					roundAttack.fsm:doEvent("attackFinishEvt", paramData)
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
