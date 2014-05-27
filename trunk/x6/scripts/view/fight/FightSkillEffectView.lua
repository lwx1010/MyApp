---
-- 释放技能的品阶特效
-- @module view.fight.FightSkillEffectView
--

local require = require
local class = class

local printf = printf
local ccp = ccp

local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
local CCRect = CCRect

local moduleName = "view.fight.FightSkillEffectView"
module(moduleName)

---
-- 类定义
-- @type FightSkillEffectView
--
local FightSkillEffectView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否需要翻转
-- @field [parent = #FightSkillEffectView] #bool _isNeedFlipX
-- 
FightSkillEffectView._isNeedFlipX = false

---
-- 技能名字图片id
-- @field [parent = #FightSkillEffectView] #number _skillImageId
-- 
FightSkillEffectView._skillImageId = 0

---
-- 资源回调
-- @field [parent = #FightSkillEffectView] #scheduler _cleanResSche
-- 
FightSkillEffectView._cleanResSche = nil

---
-- 资源ID
-- @field [parent = #FightSkillEffectView] #number _resId
-- 
FightSkillEffectView._resId = 0

---
-- 颜色数据
-- @field [parent = #FightSkillEffectView] #table _colorTl
-- 
FightSkillEffectView._colorTl = {}

---
-- 设置技能图片ID
-- @function [parent = #FightSkillEffectView] setSkillImageId
-- @param #number id
-- 
function FightSkillEffectView:setSkillImageId(id)
	self._skillImageId = id
end

---
-- 设置颜色数据
-- @function [parent = #FightSkillEffectView] setEffectColor
-- @param #number h 色相
-- @param #number s 饱和度 
-- @param #number b 明度
-- 
function FightSkillEffectView:setEffectColor(h, s, b)
	--self:changeSpriteHsb(self["particleNode"], h, s, b)
	self:changeSpriteHsb(self["lineSpr"], h, s, b)
	self["particleNode"]:setVisible(false)
end

---
-- 设置是否需要翻转
-- @function [parent = #FightSkillEffectView] setNeedFlipX
-- @param #bool flipX
-- 
function FightSkillEffectView:setNeedFlipX(flipX)
	self._isNeedFlipX = flipX
end

---
-- 设置特效资源ID
-- @function [parent = #FightSkillEffectView] setResId
-- 
function FightSkillEffectView:setResId(id)
	self._resId = id
end

---
-- 场景进入回调
-- @function [parent = #FightSkillEffectView] onEnter
-- 
function FightSkillEffectView:onEnter()
	local transition = require("framework.client.transition")
	local display = require("framework.client.display")
	local spriteAction = require("utils.SpriteAction")
	
	self["imageSpr"]:setPositionX(-self["imageSpr"]:getContentSize().width/2)
	local particleMoveDisX = self["particleNode"]:getPositionX() + display.width + 100
	local lineMoveDisX = self["lineSpr"]:getPositionX() -(display.width + 100)
	if self._isNeedFlipX == true then
		local oldX = self["particleNode"]:getPositionX()
		self["particleNode"]:setPositionX(particleMoveDisX)
		self["particleNode"]:setRotation(180)
		particleMoveDisX = oldX
		
		oldX = self["lineSpr"]:getPositionX() 
		self["lineSpr"]:setPositionX(lineMoveDisX)
		lineMoveDisX = oldX
		
		self["lineSpr"]:setFlipX(true)
		self["imageSpr"]:setFlipX(true)
		--self._effectSpr:setFlipX(true)
		self["imageSpr"]:setPositionX(display.width + self["imageSpr"]:getContentSize().width/2)
	end
		
	transition.moveTo(self["imageSpr"],
		{
			time = 0.2,
			x = self:getContentSize().width/2,
			y = self["imageSpr"]:getPositionY(),
			easing = "SINEOUT",
		}
	)
	
	transition.moveTo(self["particleNode"],
		{
			time = 1.0,
			x = particleMoveDisX,
			y = self["particleNode"]:getPositionY(),
			onComplete = function ()
				self["particleNode"]:removeFromParentAndCleanup(true)
			end
		}
	)
	
	transition.moveTo(self["lineSpr"],
		{
			time = 1.0,
			x = lineMoveDisX,
			y = self["lineSpr"]:getPositionY(),
		}
	)
	
	local resNo = self._resId
	--if level == 2
	display.addSpriteFramesWithFile("res/effect/"..resNo..".plist", "res/effect/"..resNo..".png") --品阶特效
	
	spriteAction.spriteRunOnceAction(self["imageSpr"], resNo.."/1000%d.jpg", 0, 7,
		function ()
			local scheduler = require("framework.client.scheduler")
			if self._cleanResSche == nil then
				self._cleanResSche = scheduler.performWithDelayGlobal(
					function ()
						self:removeFromParentAndCleanup(true)
						sharedSpriteFrameCache:removeSpriteFramesFromFile("res/effect/"..resNo..".plist")
					end,
					0.2
				)
			end
		end,
		0.8/7
	)
	
	if self._textSche == nil then
		local scheduler = require("framework.client.scheduler")
		self._textSche = scheduler.performWithDelayGlobal(
			function ()
				self:_addSkillName()
				self._textSche = nil
			end,
			0.08
		)
	end
end

---
-- 添加技能名字
-- @function [parent = #FightSkillEffectView] _addSkillName
-- 
function FightSkillEffectView:_addSkillName()
	--添加技能名字
	local skillData = require("xls.SkillEffectXls").data
	local skillImageNo = skillData[self._skillImageId].NameIconNo
	if skillImageNo then
		local display = require("framework.client.display")
		local skillImage = display.newSprite("res/ui/ccb/ccbResources/layout/skillname/"..skillImageNo..".png")
		
		-- 裁剪图片
		local size = skillImage:getContentSize()
		local math = require("math")
		local textWidth = 35
		if size.width < 105 then -- 特殊处理
			size.width = 105
		end
		if size.width > 136 and size.width < 140 then
			size.width = 140
		end
		
		local textNum = math.floor(size.width/textWidth)
		printf("textNum = "..textNum)
		for i = 1, textNum do
			local image = display.newSprite("res/ui/ccb/ccbResources/layout/skillname/"..skillImageNo..".png")
			image:setClipEnabled(true)
			image:setClipRect(CCRect((i - 1)*textWidth, 0, textWidth, size.height))
			 
			self:addChild(image)
			
			local addX = 0
			if textNum > 5 then
				addX = 50
			end
			
			local offsetX = 300 - addX
			if self._isNeedFlipX then 
				offsetX = -300 + addX
			end
			
			image:setScale(6.0)
			--image:setPosition(self["imageSpr"]:getPositionX() + offsetX, self["imageSpr"]:getPositionY())
			image:setPosition(display.cx + offsetX, self["imageSpr"]:getPositionY())
			image:setVisible(false)
			image:performWithDelay(
				function ()
					-- 缩放动画
					image:setVisible(true)
					local transition = require("framework.client.transition")
					transition.scaleTo(image,
						{
							time = 0.1,
							scale = 2.0,
							delay = 0.05 * i,
							easing = "SINEOUT",
						}
					)
				end,
				0.02 * (i - 1)
			)
		end
	end
end

---
-- 构造函数
-- @function [parent = #FightSkillEffectView] ctor
--
function FightSkillEffectView:ctor()
	FightSkillEffectView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FightSkillEffectView] _create
--
function FightSkillEffectView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/skilleffect.ccbi")
	
	local display = require("framework.client.display")
	self["lineSpr"]:setPositionX(display.width + 100)
	
	--粒子序列帧特效
--	local spriteAction = require("utils.SpriteAction")
--	self._effectSpr = display.newSprite()
--	self._effectSpr:performWithDelay(
--		function ()
--			display.addSpriteFramesWithFile("res/effect/ParticleEffect.plist", "res/effect/ParticleEffect.png")
--			spriteAction.spriteRunOnceAction(self._effectSpr, "ParticleEffect/1000%d.png", 0, 5,
--				function ()
--					self._effectSpr:removeFromParentAndCleanup(true)
--				end,
--				0.6/5
--			)
--		end,
--		0.2
--	)
--	self._effectSpr:setAnchorPoint(ccp(0, 0.5))
--	self._effectSpr:setPositionY(self["imageSpr"]:getPositionY() + self["imageSpr"]:getContentSize().height/2 + 45)
--	--self._effectSpr:setScale(0.8)
--	self:addChild(self._effectSpr)
--	self._effectSpr:setVisible(false)
end 

---
-- 场景退出自动回调
-- @function [parent = #FightSkillEffectView] onExit
-- 
function FightSkillEffectView:onExit()
	if self._cleanResSche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._cleanResSche)
		self._cleanResSche = nil
	end
	
	if self._textSche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._textSche)
		self._textSche = nil
	end
	
	self["particleNode"]:stopAllActions()
	self["lineSpr"]:stopAllActions()
	self["imageSpr"]:stopAllActions()
	
	instance = nil
	FightSkillEffectView.super.onExit(self)
end