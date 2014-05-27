---
-- 闭关修炼主界面
-- @module view.biguan.BiGuanMainView
-- 

local class = class
local require = require
local printf = printf


local moduleName = "view.biguan.BiGuanMainView"
module(moduleName)

---
-- 类定义
-- @type BiGuanMainView
-- 
local BiGuanMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#BiGuanMainView] ctor
-- @param self
-- 
function BiGuanMainView:ctor()
	BiGuanMainView.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#BiGuanMainView] _create
-- @param self
-- 
function BiGuanMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_zhujiemian.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	
	local arr = self["tabRGrp"].menu:getChildren()
	local arr2 = self["tabRGrpLink"].menu:getChildren()
	local HeroAttr = require("model.HeroAttr")
	local xls = require("xls.PlayOpenXls").data
	-- 是否开启传功
--	if HeroAttr.Grade >= xls["chuangong"].StartLevel then
	if HeroAttr.Grade >= xls["biguanxiulian"].StartLevel then
		arr:objectAtIndex(1):setVisible(true)
		arr2:objectAtIndex(1):setVisible(true)
	else
		arr:objectAtIndex(1):setVisible(false)
		arr2:objectAtIndex(1):setVisible(false)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#BiGuanMainView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiGuanMainView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent = #BiGuanMainView] openUi
-- @param #number index
-- 
function BiGuanMainView:openUi(index)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	if index then
		self["tabRGrp"]:setSelectedIndex(index, false)
	else
		self["tabRGrp"]:setSelectedIndex(1, false)
	end
	
	self:_tabClkHandler()
end

--- 
-- 点击了tab
-- @function [parent=#BiGuanMainView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function BiGuanMainView:_tabClkHandler( event )
	self["itemHBox"]:removeAllItems()
	
	local index = self["tabRGrp"]:getSelectedIndex()
	if index == 2  then
		local BiGuanView = require("view.biguan.BiGuanView")
		self["itemHBox"]:addItem(BiGuanView.createInstance())
		BiGuanView.instance:showPartner()
	elseif index == 1 then
		local ChuanGongUi = require("view.biguan.ChuanGongUi")
		self["itemHBox"]:addItem(ChuanGongUi.createInstance())
		ChuanGongUi.instance:showPartner()
	end
end

---
-- 退出界面调用
-- @function [parent=#PartnerMainView] onExit
-- @param self
-- 
function BiGuanMainView:onExit()
	instance = nil
	BiGuanMainView.super.onExit(self)
end









