---
-- 吞元界面同伴子项
-- @module view.partner.sub.TunYuanPartnerCell
-- 

local class = class
local require = require
local tostring = tostring
local tr = tr
local printf = printf
local CCTextureCache = CCTextureCache
local dump = dump

local moduleName = "view.partner.sub.TunYuanPartnerCell"
module(moduleName)

---
-- 类定义
-- @type TunYuanPartnerCell
-- 
local TunYuanPartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴信息
-- @field [parent=#TunYuanPartnerCell] #table _partner 
-- 
TunYuanPartnerCell._partner = nil

---
-- 创建实例
-- @return #TunYuanPartnerCell 
-- 
function new()
	return TunYuanPartnerCell.new()
end

---
-- 构造函数
-- @function [parent=#TunYuanPartnerCell] ctor
-- @param self
-- 
function TunYuanPartnerCell:ctor()
	TunYuanPartnerCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#TunYuanPartnerCell] _create
-- @param self
-- 
function TunYuanPartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_eatingpiece.ccbi", true)
end

---
-- 显示数据
-- @function [parent=#TunYuanPartnerCell] showItem
-- @param self
-- @param #table partner 同伴信息
-- 
function TunYuanPartnerCell:showItem(partner)
	self._partner = partner
	
	if( not partner ) then
		self:changeTexture("headCcb.frameSpr", nil)
		self:changeTexture("headCcb.lvBgSpr", nil)
		self:changeTexture("headCcb.headPnrSpr", nil)
		self:changeTexture("headCcb.starBgSpr", nil)
		self:changeTexture("headCcb.typeBgSpr", nil)
		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("headCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("headCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["headCcb.lvLab"]:setString(partner.Grade)
	self["headCcb.headPnrSpr"]:showIcon(partner.Photo)
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step]..partner.Name)
	self["starLab"]:setString(partner.Star)
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["headCcb.starBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setVisible(true)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setString(partner.Star)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
	else
		self["headCcb.starBgSpr"]:setVisible(false)
		self["headCcb.starLab"]:setVisible(false)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
	end
	
	self:changeFrame("headCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["headCcb.typeSpr"]:setVisible(true)
end

---
-- 取同伴
-- @function [parent=#TunYuanPartnerCell] getPartner
-- @param self
-- @return #table 同伴
-- 
function TunYuanPartnerCell:getPartner()
	return self._partner
end




