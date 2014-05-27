---
-- 武功升级子项
-- @module view.martial.MartialStrengthenCell
-- 

local class = class
local require = require
local tostring = tostring
local tr = tr
local printf = printf
local CCTextureCache = CCTextureCache
local dump = dump

local moduleName = "view.martial.MartialStrengthenCell"
module(moduleName)

---
-- 类定义
-- @type MartialStrengthenCell
-- 
local MartialStrengthenCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴信息
-- @field [parent=#MartialStrengthenCell] #table _martial 
-- 
MartialStrengthenCell._martial = nil

---
-- 创建实例
-- @return #MartialStrengthenCell 
-- 
function new()
	return MartialStrengthenCell.new()
end

---
-- 构造函数
-- @function [parent=#MartialStrengthenCell] ctor
-- @param self
-- 
function MartialStrengthenCell:ctor()
	MartialStrengthenCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#MartialStrengthenCell] _create
-- @param self
-- 
function MartialStrengthenCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_skill/ui_skll2piece.ccbi", true)
end

---
-- 显示数据
-- @function [parent=#MartialStrengthenCell] showItem
-- @param self
-- @param #table martial 装备信息
-- 
function MartialStrengthenCell:showItem(martial)
	self._martial = martial
	
	if( not martial ) then
--		self:changeTexture("headCcb.frameSpr", nil)
--		self:changeTexture("headCcb.lvBgSpr", nil)
--		self:changeTexture("headCcb.headPnrSpr", nil)
--		self:changeTexture("headCcb.starBgSpr", nil)
--		self:changeTexture("headCcb.typeBgSpr", nil)
--		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local ImageUtil = require("utils.ImageUtil")
	self:changeItemIcon("iconCcb.headPnrSpr", martial.IconNo)
	self:changeFrame("iconCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[martial.Rare])
	self:changeFrame("iconCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[martial.Rare])
	self["iconCcb.lvLab"]:setString(" "..martial.MartialLevel)
	self["martialNameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[martial.Rare] ..  martial.Name)
	self["martialStepLab"]:setString(tr("第")..martial.MartialRealm .. "/" .. (martial.MartialRealmMax or 20 ) .. tr("重"))
	self["martialLvLab"]:setString(martial.MartialLevel .. "/" .. (martial.ShowMartialLevelMax or 5) .. tr("级") )
	
	if martial.EquipPartnerId > 0 then
		local PartnerData = require("model.PartnerData")
		local PartnerShowConst = require("view.const.PartnerShowConst")
		local partner = PartnerData.findPartner(martial.EquipPartnerId)
		if partner then 
			self["ownerLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] .. partner.Name )
		else
			self["ownerLab"]:setString( "" )
		end
	else
		self["ownerLab"]:setString( "" )
	end
end



