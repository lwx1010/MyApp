--- 
-- 更改阵容界面子项
-- @module view.partner.PartnerItemCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr
local ccp = ccp
local display = display
local ui = ui

local moduleName = "view.partner.PartnerItemCell"
module(moduleName)


--- 
-- 类定义
-- @type PartnerItemCell
-- 
local PartnerItemCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴
-- @field [parent=#PartnerItemCell] model.Item#Item _partner
-- 
PartnerItemCell._partner = nil

---
-- 创建实例
-- @return PartnerItemCell实例
function new()
	return PartnerItemCell.new()
end

--- 
-- 构造函数
-- @function [parent=#PartnerItemCell] ctor
-- @param self
-- 
function PartnerItemCell:ctor()
	PartnerItemCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#PartnerItemCell] _create
-- @param self
-- 
function PartnerItemCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_zhengrong1.ccbi", true)
	
	self:changeTexture("headCcb.lvBgSpr", nil)
	self["headCcb.lvLab"]:setVisible(false)
	
	self:createClkHelper(true)
	self:addClkUi("headCcb")
	
	self:handleButtonEvent("onCcb.aBtn", self._onClkHandler)
	
	self["nameLab"]:setVisible(false)
	self["nameText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 482,
					}
				 )
	self["nameText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["nameText"])
end

---
-- 设置描边文字
-- @function [parent=#PartnerItemCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function PartnerItemCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 点击了上阵/替换按钮
-- @function [parent=#PartnerItemCell] _selectClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerItemCell:_onClkHandler( sender, event )
	if not self.owner or not self.owner.owner or not self._partner then return end
	
	local view = self.owner.owner
	view:setPartnerFight(self._partner.Id, self._partner.War)
end

--- 
-- 显示数据
-- @function [parent=#PartnerItemCell] showItem
-- @param self
-- @param model.Partner#Partner partner 道具
-- 
function PartnerItemCell:showItem( partner )
	self._partner = partner
	
	if( not partner ) then
		self:changeItemIcon("headCcb.headPnrSpr", nil)
		self:changeTexture("headCcb.frameSpr", nil)
		self:changeTexture("rareSpr", nil)
		
		self:changeTexture("headCcb.starBgSpr", nil)
		self:changeTexture("headCcb.typeBgSpr", nil)
		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	-- 是否是假道具(没有道具补全界面用到)
	if( partner.isFalse ) then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["nameText"]:setVisible(false)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:_setText("nameText", partner.Name, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
	self["nameText"]:setVisible(true)
--	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[partner.Step])
	self["lvLab"]:setString( "" .. partner.Grade .. "级" )
	self["headCcb.headPnrSpr"]:showIcon(partner.Photo)
	self:changeFrame("headCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	
	self["scoreLab"]:setString("" .. (partner.Score or "0") )
	
	local types = {"进攻型","防守型","均衡型","内力狂人"}
	self["typeLab"]:setString(types[partner.Type])
	
	local sprName
	for i=1, 7 do
		sprName = "starSpr"..i
		if(i<=partner.Star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>partner.Star and i<=partner.CanUpStarNum) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
		end
	end
	
	if( partner.isReplace ) then
		self:changeFrame("onCcbSpr", "ccb/buttontitle/change.png")
	else
		self:changeFrame("onCcbSpr", "ccb/buttontitle/puton.png")
	end
	
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
	self:changeFrame("headCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["headCcb.typeSpr"]:setVisible(true)
end

---
-- ui点击处理
-- @function [parent=#PartnerItemCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function PartnerItemCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or self._partner.isFalse ) then return end
	
	local BagPartnerInfoUi = require("view.bag.BagPartnerInfoUi")
	BagPartnerInfoUi.createInstance():openUi(self._partner, false)
end

---
-- 取同伴
-- @function [parent=#PartnerItemCell] getPartner
-- @param self
-- @return #Partner 
-- 
function PartnerItemCell:getPartner()
	return self._partner
end

