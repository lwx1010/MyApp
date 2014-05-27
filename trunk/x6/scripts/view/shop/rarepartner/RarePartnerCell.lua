--- 
-- 贤士谱子项
-- @module view.shop.rarepartner.RarePartnerCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr
local ccc3 = ccc3

local moduleName = "view.shop.rarepartner.RarePartnerCell"
module(moduleName)


--- 
-- 类定义
-- @type RarePartnerCell
-- 
local RarePartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return RarePartnerCell实例
function new()
	return RarePartnerCell.new()
end

--- 
-- 构造函数
-- @function [parent=#RarePartnerCell] ctor
-- @param self
-- 
function RarePartnerCell:ctor()
	RarePartnerCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#RarePartnerCell] _create
-- @param self
-- 
function RarePartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_piece.ccbi", true)
	
	self:changeTexture("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setVisible(false)
end

--- 
-- 显示数据
-- @function [parent=#RarePartnerCell] showItem
-- @param self
-- @param model.Partner#Partner partner 道具
-- 
function RarePartnerCell:showItem( partner )
	if( not partner ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[partner.Step])
	self["itemCcb.headPnrSpr"]:showIcon(partner.Photo)
	self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	
	local types = {tr("进攻型"), tr("防守型"), tr("均衡型"), tr("内力狂人")}
	self["typeLab"]:setString(tr(types[partner.Type]))
	
	self["conLab"]:setString(tr(partner.Con))
	self["staLab"]:setString(tr(partner.Sta))
	self["strLab"]:setString(tr(partner.Str))
	self["dexLab"]:setString(tr(partner.Dex))
	
	self["dexLab"]:setColor(ccc3(00, 66, 33))
	self["conLab"]:setColor(ccc3(00, 66, 33))
	self["strLab"]:setColor(ccc3(00, 66, 33))
	self["staLab"]:setColor(ccc3(00, 66, 33))
	self["typeLab"]:setColor(ccc3(00, 66, 33))
	
	self["desLab"]:setString(partner.Des)
end

