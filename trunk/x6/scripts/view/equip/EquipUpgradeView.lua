--- 
-- 强化分界面-升阶
-- @module view.equip.EquipUpgradeView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.equip.EquipUpgradeView"
module(moduleName)


--- 
-- 类定义
-- @type EquipUpgradeView
-- 
local EquipUpgradeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#EquipUpgradeView] model.Item#Item _item
-- 
EquipUpgradeView._item = nil

--- 
-- 升阶所需银两
-- @field @field [parent=#EquipUpgradeView] #number _needCash
-- 
EquipUpgradeView._needCash = nil

--- 
-- 构造函数
-- @function [parent=#EquipUpgradeView] ctor
-- @param self
-- 
function EquipUpgradeView:ctor()
	EquipUpgradeView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipUpgradeView] _create
-- @param self
-- 
function EquipUpgradeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_equipupgrade.ccbi", true)
	
	self:handleButtonEvent("upgradeCcb.aBtn", self._upgradeClkHandler)
	
end

--- 
-- 设置道具
-- @function [parent=#EquipUpgradeView] setItem
-- @param self
-- @param model.Item#Item item
-- 
function EquipUpgradeView:setItem( item )
	self._item = item
end 

---
-- 点击了升阶
-- @function [parent=#EquipUpgradeView] _upgradeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipUpgradeView:_upgradeClkHandler( sender, event )
	printf("EquipUpgradeView:" .. "you have clicked then upgradeCcb.aBtn")
	if not self._item then return end
	
	local hero = require("model.HeroAttr")
	local FloatNotify = require("view.notify.FloatNotify")
	if hero.Cash < self._needCash then 
		FloatNotify.show(tr("银两不足，无法升阶！"))
		return
	end
	
	local count = self:getUpgradeEquipCount()
	if (not count) or (count < 2) then 
		FloatNotify.show( tr("材料不足，无法升阶！") )
		return
	end
	
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_update", { id = self._item.Id })
end

---
-- 显示基础信息
-- @function [parent=#EquipUpgradeView] showBaseInfo
-- @param self
-- @param model.Item#Item item
-- @param table info
-- 
function EquipUpgradeView:showBaseInfo( item, info )
	if not self._item or not item or not info then return end
	if item.Id ~= self._item.Id then return end
	
	local ItemConst = require("model.const.ItemConst")
	local str = ""
	if self._item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then 
		str = tr("<c5>攻击  +")
		if info.Ap and info.Ap > 0 then
			str = str .. info.Ap
		elseif info.ApRate and info.ApRate > 0 then
			str = str .. info.ApRate/100 .. "%"
		end
	elseif self._item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		str = tr("<c5>防御  +")
		if info.Dp and info.Dp > 0 then
			str = str .. info.Dp
		elseif info.DpRate and info.DpRate > 0 then
			str = str .. info.DpRate/100 .. "%"
		end
	elseif self._item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
		str = tr("<c5>生命  +")
		if info.Hp and  info.Hp > 0 then
			str = str .. info.Hp
		elseif info.HpRate and info.HpRate > 0 then
			str = str .. info.HpRate/100 .. "%"
		end
	end
	
	self["baseAttrLab"]:setString(str)
end

---
-- 显示装备升阶信息
-- @function [parent=#EquipUpgradeView] showEquipInfo
-- @param self
-- @param #Item item 装备道具
-- @param #number step 神兵阶位
-- @param #table info 神兵属性
-- @param #number cost 神兵升阶消耗
-- 
function EquipUpgradeView:showEquipInfo( item, step, info, cost )
	self._item = item
	
	if( not item ) then
		printf(tr("道具不存在"))
		return
	end

	self["addAttr1Lab"]:setString("")
	self["addAttr2Lab"]:setString("")
	self["addAttr3Lab"]:setString("")
	self["addAttr4Lab"]:setString("")
	self["addAttr5Lab"]:setString("")
	self["addAttr6Lab"]:setString("")
	local labName = ""
	local Prop = {}
	for k,v in pairs(info) do
		Prop[info[k].key] = info[k].value
	end
	local index = 1
	local ItemViewConst = require("view.const.ItemViewConst")
	for k, v in pairs( ItemViewConst.SHENBING_ADD_KEY ) do
		if Prop[v] then
			labName = "addAttr" .. index .. "Lab"
			self[labName]:setString("<c5>" .. ItemViewConst.SHENBING_ADD_INFO[v] .. " + " .. Prop[v]/100 .. "%" )
			index = index + 1
		end
	end
	
	self["equipNameLab"]:setString("<c5>"..self._item.Name .. ItemViewConst.SHENBING_STEPS[step + 1] .. tr("阶"))
	
	if self._item.Step == step then
		self["descLab"]:setString(tr("该神兵已达到最高阶!!!"))
		self["costLab"]:setString("")
		self["curHaveLab"]:setString("")
		self._needCash = nil
		self:showBtn("upgradeCcb", false)
	else 
		self["descLab"]:setString(tr("进阶至<c5>") .. ItemViewConst.SHENBING_STEPS[step + 1] .. tr("阶<c0>需要消耗<c5>")..self._item.Name ..ItemViewConst.SHENBING_STEPS[self._item.Step + 1] ..tr("阶<c1>*2") )
		self["costLab"]:setString(tr("消耗： <c8>") .. cost .. tr("<c0>银两"))
		self._needCash = cost
		local hero = require("model.HeroAttr")
		self["curHaveLab"]:setString(tr("您有：<c8>") .. hero.Cash .. tr("<c0>银两"))
		self:showBtn("upgradeCcb", true)
	end
end

--- 
-- 获取与要升阶神兵同阶同类的神兵数量
-- @function [parent=#EquipUpgradeView] getUpgradeEquipCount
-- @param self
-- @return #(number or nil)
-- 
function EquipUpgradeView:getUpgradeEquipCount()
	if not self._item then return end
	
	local ItemData = require("model.ItemData")
	local arr = ItemData.itemEquipListSet:getArray()
	if not arr then return 0 end
	
	local count = 0
	for i = 1, #arr do
		local item = arr[i]
		if item and item.ItemNo == self._item.ItemNo and item.Step == self._item.Step and item.EquipPartnerId == 0 and item.Id ~= self._item.Id then
			count = count + 1
		end 
	end
	
	return count
end

---
-- 退出界面调用
-- @function [parent=#EquipUpgradeView] onExit
-- @param self
-- 
function EquipUpgradeView:onExit()
	instance = nil
	EquipUpgradeView.super.onExit(self)
end
