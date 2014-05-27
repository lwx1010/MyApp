---
-- 精灵动作 模块
-- @module utils.SpriteAction
-- 

local require = require
local display = display
local transition = transition
local assert = assert
local CCFileUtils = CCFileUtils
local CCDictionary = CCDictionary
local tolua = tolua
local CCMoveTo = CCMoveTo
local ccp = ccp 

local moduleName = "utils.SpriteAction" 
module(moduleName)

--- 
-- 精灵播放永久动作
-- @function [parent = #utils.SpriteAction] spriteRunForeverAction
-- @param #CCSprite sprite 精灵
-- @param #string imageName 图片路径
-- @param #number start 开始帧数
-- @param #number length 长度
-- @param #number playSpeed 播放速度  1/4 表示 1秒播放4帧
-- @param #number delay 延迟
-- @return #CCAction action 动作 
--  
function spriteRunForeverAction(sprite, imageName, start, length, playSpeed, delay)
	local frames    = display.newFrames(imageName, start, length)
	if playSpeed == nil then
		playSpeed = 1/4  -- 1s play 4 frames
	else
		assert(playSpeed > 0)
	end
	local animation = display.newAnimation(frames, playSpeed) 

	local action = transition.playAnimationForever(sprite, animation, delay)
	return action
end


--- 
-- 精灵播放一次动作
-- @function [parent = #utils.SpriteAction] spriteRunOnceAction
-- @param #CCSprite sprite 精灵
-- @param #string imageName 图片路径
-- @param #number start 开始帧数
-- @param #number length 长度
-- @param #function onComplete 动作完成回调
-- @param #number playSpeed 播放速度  1/4 表示 1秒播放4帧
-- @param #number delay 延迟
-- @return #CCAction action 动作
-- 
function spriteRunOnceAction(sprite, imageName, start, length, onComplete, playSpeed, delay)
	local frames    = display.newFrames(imageName, start, length)
	if playSpeed == nil then
		playSpeed = 1/6  -- 1s play 6 frames
	else
		assert(playSpeed > 0)
	end
	local animation = display.newAnimation(frames, playSpeed)

	local action = transition.playAnimationOnce(sprite, animation, false, onComplete, delay)
	return action
end

---
-- 获取一个plist文件里面的帧数
-- @function [parent = #utils.SpriteAction] getPlistFrame
-- @param #string plistName
--
function getPlistFrame(plistName)
	local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(plistName)
	local plistDic = CCDictionary:createWithContentsOfFile(fullpath)
	local frames = tolua.cast(plistDic:objectForKey("frames"), "CCDictionary")
	return frames:count()
end

---
-- 结算界面胜利/失败的图片动作
-- @function [parent = #utils.SpriteAction] resultScaleSprAction
-- @param #CCSprite sprite
-- @param #table param
-- 
function resultScaleSprAction(sprite, param)
	param = param or {}
	transition.scaleTo(sprite,
		{
			time = param.time or 0.4,
			scale = param.scale or 1.0,
			easing = param.easing or "CCEaseElasticOut",
			onComplete = param.onComplete or nil,
			delay = param.delay or 0
		}
	)
end

---
-- 结束界面画布的运动
-- @function [parent = #utils.SpriteAction] resultLayoutAction
-- @param #CCSprite layout
-- @param #table
-- 
function resultLayoutAction(layout, param)
	param = param or {}
	transition.moveTo(layout,
		{
			time = param.time or 0.2,
			x = param.x or 0,
			y = param.y or 0,
			easing = param.easing or "CCEaseElasticOut",
			onComplete = param.onComplete or nil,
			delay = param.delay or 0
		}
	)
end

---
-- 摇动特效，左右上下摇动
-- @function [parent = #utils.SpriteAction] _shake
-- @param #CCNode target
-- @param #number strengthX X方向的力度
-- @param #number strengthY Y方向的力度
-- 
function shakeSprite(target, strengthX, strengthY)
	-- 振动特效
	if not strengthX then strengthX = 0 end
	if not strengthY then strengthY = 0 end
	
	local x = target:getPositionX()
	local y = target:getPositionY()
	local shakeAction = transition.sequence(
		{
			CCMoveTo:create(0.05, ccp(x - strengthX,y - strengthY)),
			CCMoveTo:create(0.05, ccp(x + strengthX,y + strengthY)),
			CCMoveTo:create(0.05, ccp(x - strengthX/2,y - strengthY/2)),
			CCMoveTo:create(0.05, ccp(x + strengthX/2,y + strengthY/2)),
			CCMoveTo:create(0.05, ccp(x, y))
		}
	)
		
	target:runAction(shakeAction)
end