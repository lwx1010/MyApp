---
-- 战斗特殊处理特效
-- @module view.fight.FightEffect
--

local require = require

local moduleName = "view.fight.FightEffect"
module(moduleName)

function testEffect(allied)
	local display = require("framework.client.display")
	local spriteAction = require("utils.SpriteAction")
	local node = display.newNode()
	
	display.addSpriteFramesWithFile("effect/20100011.plist", "effect/20100011.png")
	
	local effect1 = display.newSprite("#20100011/10000.png")
	
	--spriteAction.spriteRunForeverAction(effect, "20100011/1000%d.png", 0, 2, 0.5/2)
	node:addChild(effect1)
	
	local effect2 = display.newSprite("#20100011/10001.png")
	
	node:addChild(effect2)
	
--	local effect = display.newSprite()
--	spriteAction.spriteRunForeverAction(effect, "20100011/1000%d.png", 0, 2, 0.5/2)
--	effect:setPosition(40, 20)
--	effect:setRotation(30)
--	node:addChild(effect)
--	
--	local effect = display.newSprite()
--	spriteAction.spriteRunForeverAction(effect, "20100011/1000%d.png", 0, 2, 0.5/2)
--	effect:setPosition(40, -20)
--	effect:setRotation(-30)
--	node:addChild(effect)
	
	local transition = require("framework.client.transition")
	if allied == 0 then
		effect1:setPosition(0, 300)
		effect2:setPosition(0, 300)
		transition.moveTo(effect1,
			{
				x = display.width + 200,
				y = 300,
				time = 0.3,
				onComplete = function ()
					node:removeFromParentAndCleanup(true)
				end
			}
		)
		
		transition.moveTo(effect2,
			{
				x = display.width + 200,
				y = 300,
				time = 0.4,
				onComplete = function ()
					node:removeFromParentAndCleanup(true)
				end
			}
		)
--		transition.fadeTo(node,
--			{
--				time = 0.6,
--				opacity = 100
--			}
--		)
		transition.scaleTo(effect1,
			{
				time = 0.3,
				scale = 1.5
			}
		)
		transition.scaleTo(effect2,
			{
				time = 0.3,
				scale = 1.5
			}
		)
	else
		node:setPosition(830, 300)
		transition.moveTo(node,
			{
				x = 230, 
				y = 300,
				time = 0.4,
				onComplete = function ()
					node:removeFromParentAndCleanup(true)
				end
			}
		)
	end
	
	return node
end