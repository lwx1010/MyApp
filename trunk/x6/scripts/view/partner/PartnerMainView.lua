---
-- 同伴系统主界面
-- @module view.partner.PartnerMainView
-- 

local class = class
local require = require
local printf = printf
local table = table


local moduleName = "view.partner.PartnerMainView"
module(moduleName)


---
-- 类定义
-- @type PartnerMainView
-- 
local PartnerMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#PartnerMainView] ctor
-- @param self
-- 
function PartnerMainView:ctor()
	PartnerMainView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerMainView] _create
-- @param self
-- 
function PartnerMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_onbattle.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	
	self["itemHBox"]:setClipEnabled(false)
	local arr = self["tabRGrp"].menu:getChildren()
	local arr2 = self["tabRGrpLink"].menu:getChildren()
	local HeroAttr = require("model.HeroAttr")
	local xls = require("xls.PlayOpenXls").data
	-- 是否开启鸿蒙绝
	if HeroAttr.Grade >= xls["hongmengjue"].StartLevel then
		arr:objectAtIndex(2):setVisible(true)
		arr2:objectAtIndex(2):setVisible(true)
	else
		arr:objectAtIndex(2):setVisible(false)
		arr2:objectAtIndex(2):setVisible(false)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#PartnerMainView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerMainView:_closeClkHandler( sender, event )
	self["itemHBox"]:removeAllItems()
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

--- 
-- 点击了tab
-- @function [parent=#PartnerMainView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function PartnerMainView:_tabClkHandler( event )
	self["itemHBox"]:removeAllItems()
	
	self._selectedIndex = self["tabRGrp"]:getSelectedIndex()
	if(self._selectedIndex==1) then
		local PartnerView = require("view.partner.PartnerView")
		if( PartnerView.instance ) then
			self["itemHBox"]:addItem(PartnerView.instance)
		else
			self["itemHBox"]:addItem(PartnerView.createInstance())
			local PartnerData = require("model.PartnerData")
			local set = PartnerData.warPartnerSet
			local partner = set:getItemAt(1)
			PartnerView.instance:showCard(partner)
		end
	elseif(self._selectedIndex==2) then
		local BattleFormationView = require("view.formation.BattleFormationView")
		if( BattleFormationView.instance ) then
			self["itemHBox"]:addItem(BattleFormationView.instance)
		else
			self["itemHBox"]:addItem(BattleFormationView.createInstance())
		end
		BattleFormationView.instance:openUi()
	elseif(self._selectedIndex==3) then
		local HeroAttr = require("model.HeroAttr")
		if( HeroAttr.Hongmeng and HeroAttr.Hongmeng>=1 and HeroAttr.Hongmeng<=4 ) then
			local HmjView = require("view.partner.hmj.HmjView")
			self["itemHBox"]:addItem(HmjView.createInstance())
			HmjView.instance:showAnimal(HeroAttr.Hongmeng)
		else
			local HmjSelectUi = require("view.partner.hmj.HmjSelectUi").new()
			self["itemHBox"]:addItem(HmjSelectUi)
		end
	end
end

---
-- 显示阵容界面信息
-- @function [parent=#PartnerMainView] showInfo
-- @param self
-- @param model#Partner partner 同伴
-- 
function PartnerMainView:showInfo( partner )
	self["itemHBox"]:removeAllItems()
	
	self["tabRGrp"]:setSelectedIndex(1, false)
	local PartnerView = require("view.partner.PartnerView")
	if( PartnerView.instance ) then
		self["itemHBox"]:addItem(PartnerView.instance)
	else
		self["itemHBox"]:addItem(PartnerView.createInstance())
	end
	PartnerView.instance:showCard(partner)
end

---
-- 显示布阵信息
-- @function [parent = #PartnerMainView] openUi
-- @param #number index
-- 
function PartnerMainView:openUi(index)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	if index then
		self["tabRGrp"]:setSelectedIndex(index, false)
	end
	
	self:_tabClkHandler()
end

---
-- 显示鸿蒙绝界面
-- @function [parent=#PartnerMainView] showHmj
-- @param self
-- @param #number type 选择的灵兽类型
-- 
function PartnerMainView:showHmj(type)
	self["itemHBox"]:removeAllItems()
	local HmjView = require("view.partner.hmj.HmjView")
	self["itemHBox"]:addItem(HmjView.createInstance())
	HmjView.instance:showAnimal(type)
end

---
-- 显示重新选择灵兽界面
-- @function [parent=#PartnerMainView] showSelectUi
-- @param self
-- 
function PartnerMainView:showSelectUi()
	self["itemHBox"]:removeAllItems()
	local HmjSelectUi = require("view.partner.hmj.HmjSelectUi").new()
	self["itemHBox"]:addItem(HmjSelectUi)
end

---
-- 退出界面调用
-- @function [parent=#PartnerMainView] onExit
-- @param self
-- 
function PartnerMainView:onExit()
	instance = nil
	PartnerMainView.super.onExit(self)
end

