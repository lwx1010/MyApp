---
-- 水波特效
-- @module view.effect.RippleEffect
--

local CCSize = CCSize
local CCRipple3D = CCRipple3D
local ccp = ccp
local require = require
local CCDirector = CCDirector
local kCCDirectorProjection2D = kCCDirectorProjection2D
local kCCDirectorProjection3D = kCCDirectorProjection3D

local moduleName = "view.effect.RippleEffect"
module(moduleName)

---
-- 水波数量
-- @field [parent = #view.effect.RippleEffect] #number _rippleNum
-- 
local _rippleNum = 0

---
-- 在屏幕上创建一个水波特效
-- @function [parent = #view.effect.RippleEffect] createRippleEffect
-- @param #CCNode node
-- @param #CCPoint pos
-- @param #number strength 力度
-- 
function createRippleEffect(node, pos, strength)
--	if strength == nil then
--		strength = 0
--	end
--	
--	_rippleNum = _rippleNum + 1
--	
--	-- 转cocos2d-x 为透视投影
--	local director = CCDirector:sharedDirector() 
--	director:setProjection(kCCDirectorProjection3D)
--	
--  	local gridSize = CCSize(64, 52)
--	node:runAction(CCRipple3D:create(1, gridSize, pos, 120 + strength, 3, 40))
--	local scheduler = require("framework.client.scheduler")
--	scheduler.performWithDelayGlobal(
--		function ()
--			_rippleNum = _rippleNum - 1
--			if _rippleNum == 0 then
--				local director = CCDirector:sharedDirector() 
--				director:setProjection(kCCDirectorProjection2D)
--				node:setGrid(nil)
--			end
--		end,
--		1
--	)
end 





