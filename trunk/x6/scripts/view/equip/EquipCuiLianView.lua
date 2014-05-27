--- 
-- 强化分界面-淬炼
-- @module view.equip.EquipCuiLianView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.equip.EquipCuiLianView"
module(moduleName)


--- 
-- 类定义
-- @type EquipCuiLianView
-- 
local EquipCuiLianView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#EquipCuiLianView] model.Item#Item _item
-- 
EquipCuiLianView._item = nil

--- 
-- 消耗信息
-- @field [parent=#EquipCuiLianView] #table _costInfo
-- 
EquipCuiLianView._costInfo = nil

---
-- 当前选中index
-- @field [parent=#EquipCuiLianView] #number _curIndex
-- 
EquipCuiLianView._curIndex = 0

--- 
-- 构造函数
-- @function [parent=#EquipCuiLianView] ctor
-- @param self
-- 
function EquipCuiLianView:ctor()
	EquipCuiLianView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipCuiLianView] _create
-- @param self
-- 
function EquipCuiLianView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_equiprefine.ccbi", true)
	
	self:handleButtonEvent("cuiLianCcb.aBtn", self._cuiLianClkHandler)
	self:handleMenuItemEvent("select1Ccb.aChk", self._selectClkHandler)
	self:handleMenuItemEvent("select2Ccb.aChk", self._selectClkHandler)
	self:handleMenuItemEvent("select3Ccb.aChk", self._selectClkHandler)
	
	self["select1Ccb"].data = 1
	self["select2Ccb"].data = 2
	self["select3Ccb"].data = 3
	self["select1Ccb.aChk"].data = 4
	self["select2Ccb.aChk"].data = 5
	self["select3Ccb.aChk"].data = 6
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ATTRS_UPDATED_ITEMNO.name, self._attrsUpdatedHandler, self)
end

---
-- 道具数量变换监听
-- @function [parent=#EquipCuiLianView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ATTRS_UPDATE event
-- 
function EquipCuiLianView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item or not self._costInfo  then return end
	
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	if event.attrs.ItemNo == ItemConst.ITEMNO_TIEKUANGSHI then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_TIEKUANGSHI, ItemConst.NORMAL_FRAME)
		self["ironLab"]:setString(tr("铁矿石： ") .. cnt .. "/" .. self._costInfo.NeedIron)
		
		if self._curIndex == 3 then
			if cnt >= self._costInfo.NeedIron then
				self["cuiLianCcb.aBtn"]:setEnabled(true)
				self["cuiLianCcbSpr"]:setOpacity(255)
			else
				self["cuiLianCcb.aBtn"]:setEnabled(false)
				self["cuiLianCcbSpr"]:setOpacity(80)
			end
		end
	elseif event.attrs.ItemNo == ItemConst.ITEMNO_YINKUANGSHI then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_YINKUANGSHI, ItemConst.NORMAL_FRAME)
		self["silverLab"]:setString(tr("银矿石： ") .. cnt .. "/" .. self._costInfo.NeedSilver)
		
		if self._curIndex == 2 then
			if cnt >= self._costInfo.NeedSilver then
				self["cuiLianCcb.aBtn"]:setEnabled(true)
				self["cuiLianCcbSpr"]:setOpacity(255)
			else
				self["cuiLianCcb.aBtn"]:setEnabled(false)
				self["cuiLianCcbSpr"]:setOpacity(80)
			end
		end
	elseif event.attrs.ItemNo == ItemConst.ITEMNO_JINKUANGSHI then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_JINKUANGSHI, ItemConst.NORMAL_FRAME)
		self["goldenLab"]:setString(tr("金矿石： ") .. cnt .. "/" .. self._costInfo.NeedGold)
		
		if self._curIndex == 1 then
			if cnt >= self._costInfo.NeedGold then
				self["cuiLianCcb.aBtn"]:setEnabled(true)
				self["cuiLianCcbSpr"]:setOpacity(255)
			else
				self["cuiLianCcb.aBtn"]:setEnabled(false)
				self["cuiLianCcbSpr"]:setOpacity(80)
			end
		end
	end
end

---
-- 选择了某一个
-- @function [parent=#EquipCuiLianView] _selectClkHandler
-- @param self
-- @param #number tag
-- @param #table event
-- 
function EquipCuiLianView:_selectClkHandler(tag, event )
	if not event or not self._item then return end
	
	local canCl = false
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	if event == self["select1Ccb.aChk"] and self["select1Ccb.aChk"]:getSelectedIndex() > 0 then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_JINKUANGSHI, ItemConst.NORMAL_FRAME)
		if cnt >= self._costInfo.NeedGold then
			canCl = true
		end
		self._curIndex = 1
		self["select2Ccb.aChk"]:setSelectedIndex(0)
		self["select3Ccb.aChk"]:setSelectedIndex(0)
	elseif event == self["select2Ccb.aChk"] and self["select2Ccb.aChk"]:getSelectedIndex() > 0 then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_YINKUANGSHI, ItemConst.NORMAL_FRAME)
		if cnt >= self._costInfo.NeedSilver then
			canCl = true
		end
		self._curIndex = 2
		self["select1Ccb.aChk"]:setSelectedIndex(0)
		self["select3Ccb.aChk"]:setSelectedIndex(0)
	elseif event == self["select3Ccb.aChk"] and self["select3Ccb.aChk"]:getSelectedIndex() > 0  then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_TIEKUANGSHI, ItemConst.NORMAL_FRAME)
		if cnt >= self._costInfo.NeedIron then
			canCl = true
		end
		self._curIndex = 3
		self["select1Ccb.aChk"]:setSelectedIndex(0)
		self["select2Ccb.aChk"]:setSelectedIndex(0)
	else
		self._curIndex = 0
	end
	
	if canCl then
		self["cuiLianCcb.aBtn"]:setEnabled(true)
		self["cuiLianCcbSpr"]:setOpacity(255)
	else
		self["cuiLianCcb.aBtn"]:setEnabled(false)
		self["cuiLianCcbSpr"]:setOpacity(80)
	end
end

---
-- 点击了淬炼
-- @function [parent=#EquipCuiLianView] _cuiLianClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipCuiLianView:_cuiLianClkHandler( sender, event )
	printf("EquipCuiLianView:" .. "you have clicked then cuiLianCcb.aBtn")
	-- 加载等待
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local ItemConst = require("model.const.ItemConst")
	local sourceno 
	if self._curIndex == 1 then
		sourceno = ItemConst.ITEMNO_JINKUANGSHI
	elseif self._curIndex == 2 then
		sourceno = ItemConst.ITEMNO_YINKUANGSHI
	elseif self._curIndex == 3 then
		sourceno = ItemConst.ITEMNO_TIEKUANGSHI
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xl", {id = self._item.Id, sourceid = sourceno})
end

---
-- 设置淬炼道具
-- @function [parent=#EquipCuiLianView] setCuiLianItem
-- @param self
-- @param model.Item#Item item
-- 
function EquipCuiLianView:setCuiLianItem( item )
	self._item = item
	
	self["select1Ccb.aChk"]:setSelectedIndex(0)
	self["select2Ccb.aChk"]:setSelectedIndex(0)
	self["select3Ccb.aChk"]:setSelectedIndex(0)
	self["cuiLianCcb.aBtn"]:setEnabled(false)
	self["cuiLianCcbSpr"]:setOpacity(80)
	
	if not self._item then return end
	
	local data = require("xls.XiLianXls").data
	self._costInfo = data[self._item.Rare]
	
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	
	local cnt
	cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_TIEKUANGSHI, ItemConst.NORMAL_FRAME)
	self["ironLab"]:setString(tr("铁矿石： ") .. cnt .. "/" .. self._costInfo.NeedIron)
	cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_YINKUANGSHI, ItemConst.NORMAL_FRAME)
	self["silverLab"]:setString(tr("银矿石： ") .. cnt .. "/" .. self._costInfo.NeedSilver)
	cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_JINKUANGSHI, ItemConst.NORMAL_FRAME)
	self["goldenLab"]:setString(tr("金矿石： ") .. cnt .. "/" .. self._costInfo.NeedGold)
end

---
-- 清除界面信息
-- @function [parent=#EquipCuiLianView] clearSelectInfo
-- @param self
-- 
function EquipCuiLianView:clearSelectInfo()
--	self["select1Ccb.aChk"]:setSelectedIndex(0)
--	self["select2Ccb.aChk"]:setSelectedIndex(0)
--	self["select3Ccb.aChk"]:setSelectedIndex(0)
	
--	self["cuiLianCcb.aBtn"]:setEnabled(false)
--	self["cuiLianCcbSpr"]:setOpacity(80)
end

---
-- 退出界面调用
-- @function [parent=#EquipCuiLianView] onExit
-- @param self
-- 
function EquipCuiLianView:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ATTRS_UPDATED_ITEMNO.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	EquipCuiLianView.super.onExit(self)
end
