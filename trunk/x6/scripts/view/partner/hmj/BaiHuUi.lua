---
-- 鸿蒙绝-白虎界面
-- @module view.partner.hmj.BaiHuUi
-- 

local class = class
local require = require
local printf = printf
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local display = display
local CCScaleTo = CCScaleTo
local UIUtil = UIUtil

local moduleName = "view.partner.hmj.BaiHuUi"
module(moduleName)

---
-- 类定义
-- @type BaiHuUi
-- 
local BaiHuUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前查看的星宿
-- @field [parent=#BaiHuUi] #number _pos
-- 
BaiHuUi._pos = 0

---
-- 创建实例
-- @return #HmjCell实例
-- 
function new()
	return BaiHuUi.new()
end

---
-- 构造函数
-- @function [parent=#BaiHuUi] ctor
-- @param self
-- 
function BaiHuUi:ctor()
	BaiHuUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#BaiHuUi] _create
-- @param self
-- 
function BaiHuUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue7.ccbi", true)
	
	self:createClkHelper()
	for i=1, 7 do
--		self:addClkUi("posDesSpr"..i)
		self["posSpr"..i]:setVisible(false)
		self["selectSpr"..i]:setVisible(false)
		
		self["posSpr"..i]:setZOrder(10+i)
		self["posDesSpr"..i]:setZOrder(20+i)
		self["selectSpr"..i]:setZOrder(30+1)
	end
	
	self["fireNode1"]:setVisible(false)
	self._nodeParent = self["selectSpr1"]:getParent()
	for i=2, 7 do
		local posX = self["posSpr"..i]:getPositionX()
		local posY = self["posSpr"..i]:getPositionY()
		local copyNode = UIUtil:copyNode(self["fireNode1"], true)
		self._nodeParent:addChild(copyNode, i)
		copyNode:setPosition(posX,posY)
		self["fireNode"..i] = copyNode
	end
	
	-- 播放闪烁效果
	self:_playEffect()
end

---
-- 显示激活状态
-- @function [parent=#BaiHuUi] showActivation
-- @param self
-- @param #number pos 
-- 
function BaiHuUi:showActivation(pos)
	self["posSpr"..pos]:setVisible(true)
	self["fireNode"..pos]:setVisible(true)
--	-- 播放火焰特效
--	display.addSpriteFramesWithFile("res/ui/effect/hmj_huoyan.plist", "res/ui/effect/hmj_huoyan.png")
--	self._effect = display.newSprite()
--	self._node:addChild(self._effect, 5)
--	self._effect:setPositionX(posX)
--	self._effect:setPositionY(posY+20)
--	local frames = display.newFrames("hmj_huoyan/1000%d.png", 0, 4)
--	local animation = display.newAnimation(frames, 1/8)
--	transition.playAnimationForever(self._effect, animation)
end

---
-- 显示选中状态
-- @function [parent=#BaiHuUi] setSelect
-- @param self
-- @param #number pos 
-- 
function BaiHuUi:setSelect(pos)
	if self._pos == pos then return end
	
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
	end
	self["selectSpr"..pos]:setVisible(true)
	self._pos = pos
end

---
-- 取消选中状态
-- @function [parent=#BaiHuUi] removeSelect
-- @param self
-- 
function BaiHuUi:removeSelect()
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
		self._pos = 0
	end
end

---
-- ui点击处理
-- @function [parent=#BaiHuUi] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function BaiHuUi:uiClkHandler( ui, rect )
	local HmjView = require("view.partner.hmj.HmjView")
	for i=1, 7 do
		if ui == self["posDesSpr"..i] then
			if HmjView.instance then
				HmjView.instance:sendInfo(i)
			end
			return
		end
	end
end

---
-- 播放闪烁效果
-- @function [parent=#BaiHuUi] _playEffect
-- @param self
-- 
function BaiHuUi:_playEffect()
	local action = transition.sequence({
				CCFadeTo:create(0.5, 0.1),
				CCFadeTo:create(0.5, 255),
				})
	local actionForever = CCRepeatForever:create(action)
	self["bgSpr"]:runAction(actionForever)
end

---
-- 播放升级特效
-- @function [parent=#BaiHuUi] playGradeEffect
-- @param self
-- @param #number pos 
-- 
function BaiHuUi:playGradeEffect(pos)
	self["posSpr"..pos]:stopAllActions()
	
	local action = transition.sequence({
				CCScaleTo:create(0.2, 2),
				CCScaleTo:create(0.2, 1),
				CCScaleTo:create(0.2, 1.7),
				CCScaleTo:create(0.2, 1),
				})
	self["posSpr"..pos]:runAction(action)
end



