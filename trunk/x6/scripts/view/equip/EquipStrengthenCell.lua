---
-- 装备强化子项
-- @module view.equip.EquipStrengthenCell
-- 

local class = class
local require = require
local tostring = tostring
local tr = tr
local printf = printf
local CCTextureCache = CCTextureCache
local dump = dump

local moduleName = "view.equip.EquipStrengthenCell"
module(moduleName)

---
-- 类定义
-- @type EquipStrengthenCell
-- 
local EquipStrengthenCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴信息
-- @field [parent=#EquipStrengthenCell] #table _equip 
-- 
EquipStrengthenCell._equip = nil

---
-- 创建实例
-- @return #EquipStrengthenCell 
-- 
function new()
	return EquipStrengthenCell.new()
end

---
-- 构造函数
-- @function [parent=#EquipStrengthenCell] ctor
-- @param self
-- 
function EquipStrengthenCell:ctor()
	EquipStrengthenCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#EquipStrengthenCell] _create
-- @param self
-- 
function EquipStrengthenCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_equipstrenthen2piece.ccbi", true)
end

---
-- 显示数据
-- @function [parent=#EquipStrengthenCell] showItem
-- @param self
-- @param #table equip 装备信息
-- 
function EquipStrengthenCell:showItem(equip)
	self._equip = equip
	
	if( not equip ) then
--		self:changeTexture("headCcb.frameSpr", nil)
--		self:changeTexture("headCcb.lvBgSpr", nil)
--		self:changeTexture("headCcb.headPnrSpr", nil)
--		self:changeTexture("headCcb.starBgSpr", nil)
--		self:changeTexture("headCcb.typeBgSpr", nil)
--		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	local ImageUtil = require("utils.ImageUtil")
	self:changeItemIcon("iconCcb.headPnrSpr", equip.IconNo)
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame( "iconCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[equip.Rare] )
	self:changeFrame( "iconCcb.lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[equip.Rare] )
	
	if equip.EquipPartnerId == 0 then 
		self["ownerNameLab"]:setString("")
--		self:showBtn("changeBtn", false)
--		self:showBtn("unloadBtn", false)
	else
		local PartnerData = require("model.PartnerData")
		local PartnerShowConst = require("view.const.PartnerShowConst")
		local partner = PartnerData.findPartner( equip.EquipPartnerId )
		if partner then 
			self["ownerNameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step] .. partner.Name )
		else
			printf("equip.EquipPartnerId :" .. equip.EquipPartnerId )
			self["ownerNameLab"]:setString("")
		end
--		self:showBtn("changeBtn", true)
--		self:showBtn("unloadBtn", true)
	end
	
--	if not self._canCtr then
--		self:showBtn("changeBtn", false)
--		self:showBtn("unloadBtn", false)
--	end
	
	local str = ""
	local ItemConst = require("model.const.ItemConst")
	if equip.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then 
		str = tr("武器")
	elseif equip.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		str = tr("衣服")
	else 
		str = tr("饰品")
	end
	self["useLvLab"]:setString( tr("使用等级 ").. equip.NeedGrade )
	self["equipTypeLab"]:setString(str)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	if equip.IsShenBing == 1 then
		self["equipNameLab"]:setString("<c5>" .. equip.Name .. ItemViewConst.SHENBING_STEPS[(equip.Step or 0) + 1] .. tr("阶"))
		self["shenBingSpr"]:setVisible(true)
		self["iconCcb.lvLab"]:setString("  " .. ItemViewConst.SHENBING_STEPS[(equip.Step or 0) + 1])
	else
		self["equipNameLab"]:setString(equip.Name)
		self["iconCcb.lvLab"]:setString("" .. (equip.StrengGrade or 0))
		self["shenBingSpr"]:setVisible(false)
	end
end

---
-- 取同伴
-- @function [parent=#EquipStrengthenCell] getPartner
-- @param self
-- @return #table 同伴
-- 
function EquipStrengthenCell:getPartner()
	return self._equip
end



