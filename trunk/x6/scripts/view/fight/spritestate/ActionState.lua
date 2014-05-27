---
-- 状态入口,准备状态
-- @module view.fight.spritestate.ActionState
--

local require = require
local ccc3 = ccc3
local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()

local printf = printf
local dump = dump

local moduleName = "view.fight.spritestate.ActionState"
module(moduleName)

---
-- 杀招图层
-- @field [parent = #view.fight.spritestate.ActionState] #number SHA_ZHAO_LAYER_NO
-- 
local SHA_ZHAO_LAYER_NO = 999

---
-- 人物初始化后输入状态的入口
-- @function [parent = #view.fight.spritestate.ActionState] onBeforeStandToAction
-- @param #table param
-- 
function onBeforeStandToAction(param)
	--dump(param)
	local ui = require("framework.client.ui")
	local fightCommon = require("view.fight.FightCommon")
	
	local actorTable = param
	--dump(param)
	if actorTable == nil then
		-- 异常处理
		printf("actorTable == nil , error")
		return 
	end
	
	--fightCommon.setSpriteTable(actorTable)
	
	--local currSpr = fightCommon.getCurrAttackSprite()
	local currSpr = actorTable.attackTable[1]
	
	--显示技能名字
	if currSpr.skillID ~= nil then
		local skillXls = require("xls.SkillEffectXls").data
		local skillWeapon = require("xls.SkillWeaponXls").data
		currSpr.behaviour = skillXls[currSpr.skillID].Behaviour
		currSpr.skillType = skillXls[currSpr.skillID].SkillType
		currSpr.targetType = skillXls[currSpr.skillID].TargetType
		currSpr.skillSound = skillXls[currSpr.skillID].Sound
		currSpr.level = skillXls[currSpr.skillID].Level
		currSpr.skillFullScreen = skillXls[currSpr.skillID].FullScreen  -- 1 or nil
		local martialId = skillXls[currSpr.skillID].MartialId
		currSpr.skillWeapon = skillWeapon[martialId].FitWeapon
		
		--_roundAttack.behaviour = 2
		if skillXls[currSpr.skillID].EffectRes ~= nil then
			currSpr.effectRes = skillXls[currSpr.skillID].EffectRes
			local text = ui.newTTFLabelWithShadow(
				{
					text = skillXls[currSpr.skillID].Name,
					color = ccc3(0, 255, 0),
					size = 28,
					align = ui.TEXT_ALIGN_CENTER,
					x = currSpr.spriteWidth/2,
					y = currSpr.spriteHeight/2 + 100,
				}
			)
			
			currSpr:addChild(text)
			
			fightCommon.tipEffect(text)
		end
	end
	
	--fsm:doEvent("")
end

---
-- 进入action状态后执行
-- @function [parent = #view.fight.spritestate.ActionState] onEnterStandToAction
-- @param #table param
-- 
function onEnterStandToAction(param)	
	-- 是近战还是远程
	--dump(param)
	local fightCommon = require("view.fight.FightCommon")
	local fightScene = require("view.fight.FightScene")
	--local currSpr = fightCommon.getCurrAttackSprite()
	local currSpr = param.attackTable[1]
	--local fsm = require("view.fight.FightStateMachine").getStateMachine() 
	local display = require("framework.client.display")
	local transition = require("framework.client.transition")
	
	--加速系数
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	
	-- 进入下个状态
	local function nextState()
		if currSpr then
			if currSpr.behaviour == require("view.fight.FightScene").CLOSE_ATTACK_BEHAVIOUR then
				currSpr.fsm:doEvent("closeAttackEvt", param) -- 近战
			else
				currSpr.fsm:doEvent("farAttackEvt", param) -- 远程
			end
		end
	end
	
	-- 杀招特效
	if currSpr.skillType >= 2 and currSpr.skillType <= 4 then --表示是杀招
		--先播放动画
		local shaZhaoSpr = fightCommon.getShaZhaoEffectSpr()
		if shaZhaoSpr == nil then
			local spriteAction = require("utils.SpriteAction")
			local shaZhaoEffect = display.newSprite()
			fightCommon.setShaZhaoEffectSpr(shaZhaoEffect)                          
			require("view.fight.FightScene").getFightScene():addChild(shaZhaoEffect, SHA_ZHAO_LAYER_NO)
			shaZhaoEffect:setFlipX(currSpr:isFlipX())
			shaZhaoEffect:setPosition(display.designCx, display.designCy)
			shaZhaoEffect:setScale(2)
			local resNo
			if currSpr.skillWeapon == 1 then  --拳脚
				resNo = "9000001"
			elseif currSpr.skillWeapon == 2 then -- 枪棒
				resNo = "9000003"
			elseif currSpr.skillWeapon == 3 then -- 刀剑
				resNo = "9000002"
			end
			display.addSpriteFramesWithFile("res/effect/"..resNo..".plist", "res/effect/"..resNo..".png") --杀招特效
			spriteAction.spriteRunOnceAction(shaZhaoEffect, resNo.."/1000%d.png", 1, 4,
				function ()
					fightCommon.setShaZhaoEffectSpr(nil)
					shaZhaoEffect:removeFromParentAndCleanup(true)
					sharedSpriteFrameCache:removeSpriteFramesFromFile("effect/"..resNo..".plist")						
					nextState()
				end,
				1/6/addSpeedCoefficient
			)
		end
		--背景变黑
		local fightScene = require("view.fight.FightScene")
		local scene = fightScene.getFightScene()
		if scene.blackMask ~= nil then
			if scene.blackMask.fadeHandler == nil then
				scene.blackMask.fadeHandler = transition.fadeIn(scene.blackMask, 
					{
						time = 0.5/addSpeedCoefficient
					}
				)
			end
		end
	--
	else  --非杀招
		-- 显示招式品阶特效
		fightCommon.showSkillLevelEffect(currSpr.skillID, currSpr:isFlipX(), currSpr.level)
		nextState()
	end
	  
end









