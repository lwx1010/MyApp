---
-- 鸿蒙绝-朱雀界面
-- @module view.partner.hmj.ZhuQueUi
-- 

local class = class
local require = require
local printf = printf
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local CCScaleTo = CCScaleTo
local UIUtil = UIUtil

local moduleName = "view.partner.hmj.ZhuQueUi"
module(moduleName)

---
-- 类定义
-- @type ZhuQueUi
-- 
local ZhuQueUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前查看的星宿
-- @field [parent=#ZhuQueUi] #number _pos
-- 
ZhuQueUi._pos = 0

---
-- 创建实例
-- @return #HmjCell实例
-- 
function new()
	return ZhuQueUi.new()
end

---
-- 构造函数
-- @function [parent=#ZhuQueUi] ctor
-- @param self
-- 
function ZhuQueUi:ctor()
	ZhuQueUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ZhuQueUi] _create
-- @param self
-- 
function ZhuQueUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue5.ccbi", true)
	
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
-- @function [parent=#ZhuQueUi] showActivation
-- @param self
-- @param #number pos 
-- 
function ZhuQueUi:showActivation(pos)
	self["posSpr"..pos]:setVisible(true)
	self["fireNode"..pos]:setVisible(true)
end

---
-- 显示选中状态
-- @function [parent=#ZhuQueUi] setSelect
-- @param self
-- @param #number pos 
-- 
function ZhuQueUi:setSelect(pos)
	if self._pos == pos then return end
	
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
	end
	self["selectSpr"..pos]:setVisible(true)
	self._pos = pos
end

---
-- 取消选中状态
-- @function [parent=#ZhuQueUi] removeSelect
-- @param self
-- 
function ZhuQueUi:removeSelect()
	if self._pos ~= 0 then
		self["selectSpr"..self._pos]:setVisible(false)
		self._pos = 0
	end
end

---
-- ui点击处理
-- @function [parent=#ZhuQueUi] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ZhuQueUi:uiClkHandler( ui, rect )
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
-- @function [parent=#ZhuQueUi] _playEffect
-- @param self
-- 
function ZhuQueUi:_playEffect()
	local action = transition.sequence({
				CCFadeTo:create(0.5, 0.1),
				CCFadeTo:create(0.5, 255),
				})
	local actionForever = CCRepeatForever:create(action)
	self["bgSpr"]:runAction(actionForever)
end

---
-- 播放升级特效
-- @function [parent=#ZhuQueUi] playGradeEffect
-- @param self
-- @param #number pos 
-- 
function ZhuQueUi:playGradeEffect(pos)
	self["posSpr"..pos]:stopAllActions()
	
	local action = transition.sequence({
				CCScaleTo:create(0.2, 2),
				CCScaleTo:create(0.2, 1),
				CCScaleTo:create(0.2, 1.7),
				CCScaleTo:create(0.2, 1),
				})
	self["posSpr"..pos]:runAction(action)
end


