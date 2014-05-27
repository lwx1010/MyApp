--- 
-- 第一个同伴特效
-- @module view.main.FirstPartnerEffectView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local display = display
local ccp = ccp
local CCRect = CCRect
local transition = transition

local moduleName = "view.main.FirstPartnerEffectView"
module(moduleName)

--- 
-- 类定义
-- @type FirstPartnerEffectView
-- 
local FirstPartnerEffectView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前时间
-- @field [parent=#FirstPartnerEffectView] #number _curtime
-- 
FirstPartnerEffectView._curtime = 0

---
-- 移动开始时间
-- @field [parent=#FirstPartnerEffectView] #number _moveBeginTime
-- 
FirstPartnerEffectView._moveBeginTime = 0

---
-- 总时间
-- @field [parent=#FirstPartnerEffectView] #number _totaltime
-- 
FirstPartnerEffectView._totaltime = 0

---
-- 卡牌精灵
-- @field [parent=#FirstPartnerEffectView] #CCSprite firstSpr
-- 
FirstPartnerEffectView._firstSpr = nil

---
-- 特效精灵
-- @field [parent=#FirstPartnerEffectView] #CCSprite _texiaospr
-- 
FirstPartnerEffectView._texiaospr = nil

---
-- 原始X坐标
-- @field [parent=#FirstPartnerEffectView] #number _srcX
-- 
FirstPartnerEffectView._srcX = nil

---
-- 原始Y坐标
-- @field [parent=#FirstPartnerEffectView] #number _srcY
-- 
FirstPartnerEffectView._srcY = nil

---
-- 回调函数
-- @field [parent=#FirstPartnerEffectView] #function _callback
-- 
FirstPartnerEffectView._callback = nil

--- 
-- 构造函数
-- @function [parent=#FirstPartnerEffectView] ctor
-- @param self
-- 
function FirstPartnerEffectView:ctor()
	FirstPartnerEffectView.super.ctor(self)
end

--- 
-- 显示
-- @function [parent=#FirstPartnerEffectView] _show
-- @param #number partnerno 同伴编号
-- @param #function callback 回调函数
-- 
function FirstPartnerEffectView:_show( partnerno, callback )
	local firstSpr = display.newSprite()
	firstSpr:setAnchorPoint(ccp(0,0))
	local ImageUtil = require("utils.ImageUtil")
	local tex = ImageUtil.getTexture("card/" .. partnerno .. ".jpg")
	firstSpr:setTexture(tex)
	local texSize = tex:getContentSize()
	firstSpr:setContentSize(texSize)
	firstSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	firstSpr:addChild(texiaospr)
	texiaospr:setScale(2.0)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
	local size = firstSpr:getContentSize()
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition((size.width - txsize.width)/2, (size.height - txsize.height)/2)
	
	self._firstSpr = firstSpr
	self._texiaospr = texiaospr
	self._callback = callback
	
	self._curtime = 0
	self._moveBeginTime = 2.5
	self._totaltime = 2.6
	self._srcX = display.designCx-size.width*0.5
	self._srcY = display.designCy-size.height*0.5
	
	self._firstSpr:setPosition(display.designCx-size.width*0.5, display.designCy-size.height*0.5)
	
	self:addChild(firstSpr)
	
	-- 播放音效
	local audio = require("framework.client.audio")
	audio.playEffect("sound/sound_levelup.mp3")
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	self:scheduleUpdate(function(...) self:_update(...) end, 0)
end

--- 
-- 每帧更新
-- @function [parent=#FirstPartnerEffectView] _update
-- @param #number delta 时间间隔
-- 
function FirstPartnerEffectView:_update( delta )
	self._curtime = self._curtime + delta
	
	if self._curtime < self._moveBeginTime then
		return
	end
	
	local size = self._firstSpr:getContentSize()
	
	if self._curtime >= self._totaltime then
		self:unscheduleUpdate()
		
		local xishu = 1
		self._firstSpr:setScaleX(1-(1- 104/160) * xishu)
		self._firstSpr:setScaleY(1-(1- 239/size.height) * xishu)
		self._firstSpr:setTextureRect(CCRect(xishu*30, 0, (size.width - 80*xishu) , size.height))
		self._firstSpr:setPosition(self._srcX + (201 - self._srcX)* xishu , self._srcY + (84 - self._srcY)*xishu)
		
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
		
		if self._callback then
			self._callback()
		end
		
		self._callback = nil
		return
	end
	
	
	self._texiaospr:setVisible(false)
	local xishu = (self._curtime - self._moveBeginTime)/(self._totaltime -self._moveBeginTime)
	self._firstSpr:setScaleX(1-(1- 104/160) * xishu)
	self._firstSpr:setScaleY(1-(1- 239/size.height) * xishu)
--		firstSpr:setTextureRect(CCRect(xishu*28/(1-(1- 115/160) * xishu), 0, (texSize.width - 90*xishu)/(1-(1- 286/size.height * xishu)) , texSize.height/(1-(1- 286/size.height * xishu))))
	self._firstSpr:setTextureRect(CCRect(xishu*30, 0, (size.width - 80*xishu) , size.height))
	self._firstSpr:setPosition(self._srcX + (201 - self._srcX)* xishu , self._srcY + (84 - self._srcY)*xishu)
end

--- 
-- 显示
-- @function [parent=#view.main.FirstPartnerEffectView] show
-- @param #number partnerno 同伴编号
-- @param #function callback 回调函数
-- 
function show( partnerno, callback )
	local effect = FirstPartnerEffectView.new()
	effect:_show(partnerno, callback)
end