---
-- 闭关修炼子项界面
-- @module view.biguan.CardCell
-- 

local class = class
local require = require
local toint = toint
local printf = printf


local moduleName = "view.biguan.CardCell"
module(moduleName)

---
-- 类定义
-- @type CardCell
-- 
local CardCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否选中
-- @field [parent=#CardCell] #boolean _isSelect
-- 
CardCell._isSelect = false

---
-- 当前显示的同伴
-- @field [parent=#CardCell] model.Partner#Partner _partner
-- 
CardCell._partner = nil

---
-- 创建实例
-- @return #CardCell
-- 
function new()
	return CardCell.new()
end

---
-- 构造函数
-- @function [parent=#CardCell] ctor
-- @param self
-- 
function CardCell:ctor()
	CardCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#CardCell] _create
-- @param self
-- 
function CardCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_biguan_card.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示数据
-- @function [parent=#CardCell] showItem
-- @param self
-- @param model.Partner#Partner partner 同伴
-- 
function CardCell:showItem(partner)
	self._partner = partner
	
	-- 没有值
	if( not partner ) then
		self:changeTexture("partnerCcb.frameSpr", nil)
		self:changeTexture("partnerCcb.lvBgSpr", nil)
		self:changeTexture("partnerCcb.headPnrSpr", nil)
		
		self:changeTexture("partnerCcb.starBgSpr", nil)
		self:changeTexture("partnerCcb.typeBgSpr", nil)
		self:changeTexture("partnerCcb.typeSpr", nil)
		self:changeTexture("warBgSpr", nil)
		self:changeTexture("warSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("partnerCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["partnerCcb.lvLab"]:setString( partner.Grade) 
	self["partnerCcb.headPnrSpr"]:showIcon(partner.Photo)
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["partnerCcb.starBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setVisible(true)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setString(partner.Star)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["partnerCcb.typeSpr"]:setPosition(92,26)
	else
		self["partnerCcb.starBgSpr"]:setVisible(false)
		self["partnerCcb.starLab"]:setVisible(false)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["partnerCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("partnerCcb.starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("partnerCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["partnerCcb.typeSpr"]:setVisible(true)
	
	if partner.War and partner.War > 0 then
		self:changeFrame("warBgSpr", "ccb/mark3/zuoshang.png")
		self:changeFrame("warSpr", "ccb/buttontitle/zhen.png")
		self["warBgSpr"]:setVisible(true)
		self["warSpr"]:setVisible(true)
	else
		self["warBgSpr"]:setVisible(false)
		self["warSpr"]:setVisible(false)
	end
end

---
-- ui点击处理
-- @function [parent=#CardCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function CardCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._partner ) then return end

	local view = self.owner.owner
--	view:checkXiuLian(self, self._partner)
	view:cellClkHandler(self, self._partner)
end

---
-- 设置选中状态
-- @function [parent=#CardCell] setSelectStatus
-- @param self
-- @param #boolean select 
-- 
function CardCell:setSelect(select)
	if( select ) then
	 	self:setGraySprite(self["partnerCcb.frameSpr"])
		self:setGraySprite(self["partnerCcb.lvBgSpr"])
		self:setGraySprite(self["partnerCcb.headPnrSpr"])
		
		self:setGraySprite(self["partnerCcb.starBgSpr"])
		self:setGraySprite(self["partnerCcb.typeBgSpr"])
		self:setGraySprite(self["partnerCcb.typeSpr"])
		self:setGraySprite(self["warBgSpr"])
		self:setGraySprite(self["warSpr"])
	else
		self:restoreSprite(self["partnerCcb.frameSpr"])
		self:restoreSprite(self["partnerCcb.lvBgSpr"])
		self:restoreSprite(self["partnerCcb.headPnrSpr"])
		
		self:restoreSprite(self["partnerCcb.starBgSpr"])
		self:restoreSprite(self["partnerCcb.typeBgSpr"])
		self:restoreSprite(self["partnerCcb.typeSpr"])
		self:restoreSprite(self["warBgSpr"])
		self:restoreSprite(self["warSpr"])
	end
end

