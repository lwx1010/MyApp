--- 
-- 网络数据加载界面
-- @module view.notify.NetLoading
-- 

local printf = printf
local require = require
local tr = tr
local CCLabelTTF = CCLabelTTF
local ccp = ccp
local CCSpriteFrameCache = CCSpriteFrameCache
local CCSpriteFrame = CCSpriteFrame
local CCPoint = CCPoint
local CCSprite = CCSprite

local moduleName = "view.notify.NetLoading"
module(moduleName)

---
-- 超时
-- @field [parent=#view.notify.NetLoading] #number TIME_OUT
-- 
local TIME_OUT = 30

---
-- 加载图像
-- @field [parent=#view.notify.NetLoading] #CCSprite _sprite
--
local _sprite = nil

---
-- 超时句柄
-- @field [parent=#view.notify.NetLoading] #number _timeoutHandle
-- 
local _timeoutHandle = nil

---
-- 超时处理器
-- @field [parent=#view.notify.NetLoading] #function _timeoutHandler
-- 
local _timeoutHandler = nil

---
-- 精灵帧缓存
-- @field [parent=#view.notify.NetLoading] #CCSpriteFrameCache sharedSpriteFrameCache
-- 
local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()


---
-- 显示
-- @function [parent=#view.notify.NetLoading] show
-- @param #number timeout 超时时间
-- @param #function timeoutHandler 超时处理器
-- 
function show(timeout, timeoutHandler)
	-- 超时
	local scheduler = require("framework.client.scheduler")
	if _timeoutHandle then
		scheduler.unscheduleGlobal(_timeoutHandle)
	end
	_timeoutHandle = scheduler.performWithDelayGlobal(_timeoutCallback, timeout or TIME_OUT)
	_timeoutHandler = timeoutHandler
	
	local device = require("framework.client.device")
	if device.platform=="android" then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local luaj = require("framework.client.luaj")
		luaj.callStaticMethod(className, "showBusy")
		return
	end
	
	if device.platform=="ios" then
		device.showActivityIndicator()
		return
	end
	
	if _sprite then return end
	
--	if not _sprite then
		local display = require("framework.client.display")
		sharedSpriteFrameCache:addSpriteFramesWithFile("ui/effect/dataloadingeffect.plist")
		local frames = display.newFrames("dataloadingeffect/100%02d.png", 1,11)
		
		_sprite = display.newSpriteWithFrame(frames[1])
		_sprite:setAnchorPoint(CCPoint(0, 0))
		
		local animation = display.newAnimation(frames,0.15)
		_sprite:playAnimationForever(animation)
		
--		-- 保留引用
--		for i=1, #frames do
--			frames[i]:retain()
--		end
--		
--		_sprite:retain()
--	end
	
--	local display = require("framework.client.display")
--	local frames = display.newFrames("dataloadingeffect/100%02d.png", 1,11)
--	local animation = display.newAnimation(frames,0.15)
--	_sprite:playAnimationForever(animation)
	
	local GameView = require("view.GameView")
	GameView.addPopUp(_sprite, true)
	GameView.center(_sprite)
end

---
-- 超时回调
-- @function [parent=#view.notify.NetLoading] _timeoutCallback
-- 
function _timeoutCallback()
	-- 超时处理
	if _timeoutHandler then
		_timeoutHandler()
	end

	-- 隐藏
	hide()
	
	-- 弹出提示
	local Alert = require("view.notify.Alert")
	Alert.show({text=tr("通讯超时\n请检查网络或重新操作")},{{text=tr("确定")}})
end

---
-- 隐藏
-- @function [parent=#view.notify.NetLoading] hide
-- 
function hide( )
	if _timeoutHandle then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(_timeoutHandle)
	end
	
	_timeoutHandle = nil
	_timeoutHandler = nil
	
	local device = require("framework.client.device")
	if device.platform=="android" then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local luaj = require("framework.client.luaj")
		luaj.callStaticMethod(className, "hideBusy")
		return
	end
	
	if device.platform=="ios" then
		device.hideActivityIndicator()
		return
	end
	
	if _sprite then
		_sprite:stopAllActions()
		
		local GameView = require("view.GameView")
    	GameView.removePopUp(_sprite, true)
	end
	
	_sprite = nil
end