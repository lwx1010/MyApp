---
-- 精灵 从站立到移动状态的转变
-- @module view.fight.spritestate.GoAttackMoveState
--

local require = require
local ccc3 = ccc3

local moduleName = "view.fight.spritestate.GoAttackMoveState"
module(moduleName)

---
-- 阴影间隔的绘制时间
-- @field [parent = #view.fight.spritestate.GoAttackMoveState] #number SHADOW_DRAW_TIME
-- 
local SHADOW_DRAW_TIME = 0.03

---
-- 从站立到攻击的加速系数
-- @field [parent = #view.fight.spritestate.GoAttackMoveState] #number STAND_TO_ATTACK_COEFFICIENT
-- 
local STAND_TO_ATTACK_COEFFICIENT = 1

---
-- 处理从站立到移动状态的函数
-- @function [parent = #view.fight.spritestate.GoAttackMoveState] onGoAttackMoveState
-- @param #table sprite
-- 
function onGoAttackMoveState(param)
	local sprite = param.sprite
	
	local ui = require("framework.client.ui")
	local display = require("framework.client.display")
	local math = require("math")
	local transition = require("framework.client.transition")
	local fightCommon = require("view.fight.FightCommon")
	local fightScene = require("view.fight.FightScene")
	--local fsm = require("view.fight.FightStateMachine").getStateMachine()
	
	--local attack = fightCommon.getCurrAttackSprite()
	local attack = param.attackTable[1]
	--local target = fightCommon.getCurrTargetSprite()
	local target = param.targetTable[1]
	local addFightSpeed = fightCommon.getAddFightSpeed()
	local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	
	--绘制残影
	fightCommon.drawSpriteShadow(attack, SHADOW_DRAW_TIME)
	
	local offsetX
	if target:isFlipX() == true then
		offsetX = -100
	else
		offsetX = 100
	end
	
	local moveTime = ( math.abs(attack.x - target.x)/5000 - addFightSpeed/4 )/addSpeedCoefficient * STAND_TO_ATTACK_COEFFICIENT
	
	_drawSpriteMud(attack, moveTime)		
	
	transition.moveTo(attack,
		{
			time = moveTime,
			x = target.x + offsetX,
			y = target.y - 1,
			easing = "CCEaseOut",
			onComplete = function()
				if attack then
					--延迟一段时间，再展开攻击动作
					attack:performWithDelay(
						function()
							-- 移除生成影子句柄
							attack:removeAction(attack.attackShadowSche) 
						
							attack.fsm:doEvent("attackEvt", param)
						end,
						0.2/addSpeedCoefficient
					)
				end
			end
		}
	)
	
end

---
-- 绘制脚下拖影
-- @function [parent = #view.fight.spritestate.GoAttackMoveState] _drawSpriteMud
-- @param #CCSprite sprite
-- @param #number time
-- 
function _drawSpriteMud(sprite, time)
--	display.addSpriteFramesWithFile("ui/effect/mud.plist", "ui/effect/mud.png")
--	local spriteAction = require("utils.SpriteAction")
--	local mudSprite = display.newSprite()
--	mudSprite.action = spriteAction.spriteRunOnceAction(mudSprite, "mud/1000%d.png", 0, 3, 
--		function ()
--			mudSprite:removeFromParentAndCleanup(true)
--		end,
--		time
--	)
--	sprite:addChild(mudSprite)
--	if sprite:isFlipX() == false then
--		mudSprite:setFlipX(true)
--		mudSprite:setPosition(sprite:getContentSize().width/2 - 108, sprite:getContentSize().height/2 - 70)
--	else
--		mudSprite:setFlipX(false)
--		mudSprite:setPosition(sprite:getContentSize().width/2 + 108, sprite:getContentSize().height/2 - 70)
--	end
end 





