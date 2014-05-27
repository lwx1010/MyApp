--- 
-- 同伴头像界面
-- @module view.partner.PartnerHeadCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local tolua = tolua
local pairs = pairs
local tr = tr

local moduleName = "view.partner.PartnerHeadCell"
module(moduleName)

--- 
-- 类定义
-- @type PartnerHeadCell
-- 
local PartnerHeadCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴
-- @field [parent=#PartnerHeadCell] model.Partner#Partner _partner
-- 
PartnerHeadCell._partner = nil

---
-- 解锁同伴对应等级表
-- @field [parent=#PartnerHeadCell] #table _gradeTbl
-- 
PartnerHeadCell._gradeTbl = {-1, -1, 5, 10, 15, 25}

---
-- 上阵同伴位置是否解锁
-- @field [parent=#PartnerHeadCell] #boolean _isLock
-- 
PartnerHeadCell._isLock = nil

--- 创建实例
-- @return PartnerHeadCell实例
function new()
	return PartnerHeadCell.new()
end

--- 
-- 构造函数
-- @function [parent=#PartnerHeadCell] ctor
-- @param self
-- 
function PartnerHeadCell:ctor()
	PartnerHeadCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#PartnerHeadCell] _create
-- @param self
-- 
function PartnerHeadCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_118box.ccbi", true)
	self:setContentSize(node:getContentSize())
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

--- 
-- 显示数据
-- @function [parent=#PartnerHeadCell] showItem
-- @param self
-- @param model.Partner#Partner partner 同伴
-- 
function PartnerHeadCell:showItem( partner )
	self._partner = partner

	if( partner == nil ) then
		self:changeTexture("frameSpr", nil)
		self:changeTexture("lvBgSpr", nil)
		self:changeTexture("headPnrSpr", nil)
		self["lvLab"]:setVisible(false)
		
		self:changeTexture("starBgSpr", nil)
		self:changeTexture("typeBgSpr", nil)
		self:changeTexture("typeSpr", nil)
		self["starLab"]:setVisible(false)
		return
	end
	
	local HeroAttr = require("model.HeroAttr")
	local index = self.dataIdx--self.owner:getItemIndex(self)
--	local index = self.owner:getItemIndex(self)
	if(index > HeroAttr.MaxFightPartnerCnt) then
		self["lockSpr"]:setVisible(true)
		self["lockLab"]:setVisible(true)
		self["lockLab"]:setString(self._gradeTbl[index]..tr("级解锁"))
	else
		self["lockSpr"]:setVisible(false)
		self["lockLab"]:setVisible(false)
	end

	
--	if( self._isLock or not partner ) then
	if( not partner ) then
		self:changeTexture("frameSpr", nil)
		self:changeTexture("lvBgSpr", nil)
		self:changeTexture("headPnrSpr", nil)
--		self:changeFrame("headPnrSpr", nil)
		self["lvLab"]:setVisible(false)
		
		self:changeTexture("starBgSpr", nil)
		self:changeTexture("typeBgSpr", nil)
		self:changeTexture("typeSpr", nil)
		self["starLab"]:setVisible(false)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["lvLab"]:setString(partner.Grade)
	self["lvLab"]:setVisible(true)
	self["headPnrSpr"]:showIcon(partner.Photo)
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["starBgSpr"]:setVisible(true)
		self["starLab"]:setVisible(true)
		self["typeBgSpr"]:setVisible(true)
		self["starLab"]:setString(partner.Star)
		self:changeFrame("typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["typeSpr"]:setPosition(92,26)
	else
		self["starBgSpr"]:setVisible(false)
		self["starLab"]:setVisible(false)
		self["typeBgSpr"]:setVisible(true)
		self:changeFrame("typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["typeSpr"]:setPosition(95,23)
	end
	self:changeFrame("starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["typeSpr"]:setVisible(true)
end

---
-- ui点击处理
-- @function [parent=#PartnerHeadCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function PartnerHeadCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner ) then return end
		
	local HeroAttr = require("model.HeroAttr")
	local index = self.dataIdx
	if(index > HeroAttr.MaxFightPartnerCnt) then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(self._gradeTbl[index]..tr("级解锁阵位"))
		return
	end
	
	if( not self._partner ) then
		local PartnerData = require("model.PartnerData")
		local DataSet = require("utils.DataSet")
		local dataset = DataSet.new()
		local arr =  PartnerData.partnerSet:getArray()
		local Partner = require("model.Partner")
		for k, v in pairs(arr) do
			--同编号的同伴只能上阵一个，在筛选的时候过滤掉与已出战同伴同编号的同伴
			if( v and v.War == 0 and v.Type~=4 and v.XiuLian~=1 and not PartnerData.getWarPartnerByNo(v.PartnerNo) ) then
				local obj = Partner.new()
				obj["Id"] = v["Id"]
				obj["Photo"] = v["Photo"]
				obj["Name"] = v["Name"]
				obj["Step"] = v["Step"]
				obj["Grade"] = v["Grade"]
				obj["War"] = v["War"]
				obj["Star"] = v["Star"]
				obj["CanUpStarNum"] = v["CanUpStarNum"]
				obj["Score"] = v["Score"]
				obj["Type"] = v["Type"]
				obj["isReplace"] = false -- 是否是替换上阵
				
	 			dataset:addItem( obj )
			end
		end
		
		local PartnerSelectView = require("view.partner.PartnerSelectView")
		local GameView = require("view.GameView")
		GameView.addPopUp(PartnerSelectView.createInstance(), true)
		PartnerSelectView.instance:showPartner( dataset )
		return
	end
	
	local view = self.owner.owner -- view.partner.PartnerView#PartnerView
	view:showCard(self._partner)
end

---
-- 取同伴
-- @function [parent=#PartnerHeadCell] getPartner
-- @param self
-- @return #Partner 
-- 
function PartnerHeadCell:getPartner()
	return self._partner
end

---
-- 设置选中效果
-- @function [parent=#PartnerHeadCell] setSelect
-- @param self
-- @param #boolean isSelect
-- 
function PartnerHeadCell:setSelect(isSelect)
	if(isSelect) then
		self["selectSpr"]:setVisible(true)
	else
		self["selectSpr"]:setVisible(false)
	end
end
