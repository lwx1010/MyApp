---
-- 鸿蒙绝-选择灵兽界面
-- @module view.partner.hmj.HmjSelectUi
-- 

local class = class
local require = require
local printf = printf


local moduleName = "view.partner.hmj.HmjSelectUi"
module(moduleName)

---
-- 类定义
-- @type HmjSelectUi
-- 
local HmjSelectUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return HmjSelectUi实例
-- 
function new()
	return HmjSelectUi.new()
end

---
-- 构造函数
-- @function [parent=#HmjSelectUi] ctor
-- @param self
-- 
function HmjSelectUi:ctor()
	HmjSelectUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建ccb
-- @function [parent=#HmjSelectUi] _create
-- @param self
-- 
function HmjSelectUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue.ccbi", true)
	
	local hBox = self["itemHBox"]
	hBox:setHCount(2)
	hBox:setVCount(2)
	
	self:_addItem()
end

---
-- 添加子项
-- @function [parent=#HmjSelectUi] _addItem
-- @param self
-- 
function HmjSelectUi:_addItem()
	local HmjCell = require("view.partner.hmj.HmjCell")
	for i=1, 4 do
		local cell = HmjCell.new()
		cell:showItem(i)
		self["itemHBox"]:addItem(cell)
	end
	-- 弹出提示
	local GameView = require("view.GameView")
	local HmjTipView = require("view.partner.hmj.HmjTipView").new()
	GameView.addPopUp(HmjTipView, true)
	GameView.center(HmjTipView)
end







