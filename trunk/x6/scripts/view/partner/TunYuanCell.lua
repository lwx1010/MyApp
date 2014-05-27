---
-- 吞元子项界面
-- @module view.partner.TunYuanCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tostring = tostring
local tr = tr

local moduleName = "view.partner.TunYuanCell"
module(moduleName)


---
-- 类定义
-- @type TunYuanCell
-- 
local TunYuanCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴
-- @field [parent=#TunYuanCell] #Partner _partner
-- 
TunYuanCell._partner = nil

---
-- 是否选中
-- @field [parent=#TunYuanCell] #boolean _isSelect
-- 
TunYuanCell._isSelect = false

---
-- 创建实例
-- @return #TunYuanCell
-- 
function new()
	return TunYuanCell.new()
end

---
-- 构造函数
-- @function [parent=#TunYuanCell] ctor
-- @param self
-- 
function TunYuanCell:ctor()
	TunYuanCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#TunYuanCell] _create
-- @param self
-- 
function TunYuanCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_selecteating.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
	
	self["selectSpr"]:setVisible(false)
end

---
-- 显示数据
-- @function [parent=#TunYuanCell] showItem
-- @param self
-- @param #Partner partner 同伴
-- 
function TunYuanCell:showItem(partner)
	self._partner = partner
	
--	self:setTouchEnabled(partner~=nil)
	if( not partner ) then
		self:changeTexture("headCcb.frameSpr", nil)
		self:changeTexture("headCcb.lvBgSpr", nil)
		self:changeTexture("headCcb.headPnrSpr", nil)
		self:changeTexture("chipSpr", nil)
--		self["chipLab"]:setString("")
--		self["nameLab"]:setString("")
--		self["mpLab"]:setString("")
		
		self:changeTexture("headCcb.starBgSpr", nil)
		self:changeTexture("headCcb.typeBgSpr", nil)
		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	-- 大小还丹
	if partner.Amount and partner.Amount > 0 then
		local PartnerShowConst = require("view.const.PartnerShowConst")
		self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Rare] ..  partner.Name)
		self:changeFrame("headCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Rare])
		self["headCcb.lvLab"]:setString("")
		self["headCcb.headPnrSpr"]:showReward("item",partner.IconNo)
		self["mpLab"]:setString( tostring(partner.Neili) )
		
		self:changeFrame("chipSpr", "ccb/mark/mark_2.png")
		self["chipLab"]:setString(partner.Amount - partner.selectNum)
		
		self:changeTexture("headCcb.lvBgSpr", nil)
		self:changeTexture("headCcb.starBgSpr", nil)
		self:changeTexture("headCcb.typeBgSpr", nil)
		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("headCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("headCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["headCcb.lvLab"]:setString( tostring(partner.Grade) )
	self["headCcb.headPnrSpr"]:showIcon(partner.Photo)
	self["mpLab"]:setString( tostring(partner.Neili) )
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["headCcb.starBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setVisible(true)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setString(partner.Star)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["headCcb.typeSpr"]:setPosition(92,26)
	else
		self["headCcb.starBgSpr"]:setVisible(false)
		self["headCcb.starLab"]:setVisible(false)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["headCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("headCcb.starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeTexture("chipSpr", nil)
	self["chipLab"]:setString("")
	
	local PartnerData = require("model.PartnerData")
	local p = PartnerData.findPartner( partner.Id )
	self:changeFrame("headCcb.typeSpr", PartnerShowConst.STEP_TYPE[p.Type])
	self["headCcb.typeSpr"]:setVisible(true)
end

---
-- 取同伴
-- @function [parent=#TunYuanCell] getPartner
-- @param self
-- @return #Partner 
-- 
function TunYuanCell:getPartner()
	return self._partner
end

---
-- 设置当前子项选中状态
-- @function [parent=#TunYuanCell] setSelect
-- @param self
-- @param #boolean status 是否选中
-- 
function TunYuanCell:setSelect(status)
	 self["selectSpr"]:setVisible(status)
end

---
-- ui点击处理
-- @function [parent=#TunYuanCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function TunYuanCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._partner ) then return end
	
	local isItem = false
	if self._partner.Amount and self._partner.Amount > 0 then
		isItem = true
	end
	local view = self.owner.owner
	view:updateSelectStatus(self, isItem)
end

---
-- 设置大小还丹数量
-- @function [parent=#TunYuanCell] setItemNum
-- @param self
-- @param #number value 
-- 
function TunYuanCell:setItemNum(value)
	self["chipLab"]:setString(value)
end







