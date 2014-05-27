---
-- 鸿蒙绝-玄武界面
-- @module view.partner.hmj.XuanWuUi
-- 

local class = class
local require = require
local printf = printf
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local CCScaleTo = CCScaleTo
local UIUtil = UIUtil

local moduleName = "view.partner.hmj.XuanWuUi"
module(moduleName)

---
-- 类定义
-- @type XuanWuUi
-- 
local XuanWuUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前查看的星宿
-- @field [parent=#XuanWuUi] #number _pos
-- 
XuanWuUi._pos = 0

---
-- 创建实例
-- @return #HmjCell实例
-- 
function new()
	return XuanWuUi.new()
end

---
-- 构造函数
-- @function [parent=#XuanWuUi] ctor
-- @param self
-- 
function XuanWuUi:ctor()
	XuanWuUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#XuanWuUi] _create
-- @param self
-- 
function XuanWuUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue6.ccbi", true)
	
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
-- @function [parent=#XuanWuUi] showActivation
-- @param self
-- @param #number pos 
-- 
function XuanWuUi:showActivation(pos)
	self["posSpr"..pos]:setVisible(true)
	self["fireNode"..pos]:setVisible(true)
end

---
-- 显示选中状态
-- @function [parent=#XuanWuUi] setSelect
-- @param self
-- @param #number pos 
-- 
function XuanWuUi:setSelect(pos)
	if self._pos == pos then return end
	
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
	end
	self["selectSpr"..pos]:setVisible(true)
	self._pos = pos
end

---
-- 取消选中状态
-- @function [parent=#XuanWuUi] removeSelect
-- @param self
-- 
function XuanWuUi:removeSelect()
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
		self._pos = 0
	end
end

---
-- ui点击处理
-- @function [parent=#XuanWuUi] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function XuanWuUi:uiClkHandler( ui, rect )
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
-- @function [parent=#XuanWuUi] _playEffect
-- @param self
-- 
function XuanWuUi:_playEffect()
	local action = transition.sequence({
				CCFadeTo:create(0.5, 0.1),
				CCFadeTo:create(0.5, 255),
				})
	local actionForever = CCRepeatForever:create(action)
	self["bgSpr"]:runAction(actionForever)
end

---
-- 播放升级特效
-- @function [parent=#XuanWuUi] playGradeEffect
-- @param self
-- @param #number pos 
-- 
function XuanWuUi:playGradeEffect(pos)
	self["posSpr"..pos]:stopAllActions()
	
	local action = transition.sequence({
				CCScaleTo:create(0.2, 2),
				CCScaleTo:create(0.2, 1),
				CCScaleTo:create(0.2, 1.7),
				CCScaleTo:create(0.2, 1),
				})
	self["posSpr"..pos]:runAction(action)
end


