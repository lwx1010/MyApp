--- 
-- 背包：侠客cell
-- @module view.bag.BagPartnerCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local transition = transition
local CCEaseBounceOut = CCEaseBounceOut
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc
local ccp = ccp
local CCRect = CCRect
local display = display
local ui = ui


local moduleName = "view.bag.BagPartnerCell"
module(moduleName)

--- 
-- 类定义
-- @type BagPartnerCell
-- 
local BagPartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 侠客
-- @field [parent=#BagPartnerCell] model.Partner#Partner _partner
-- 
BagPartnerCell._partner = nil

--- 创建实例
-- @return BagPartnerCell实例
function new()
	return BagPartnerCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagPartnerCell] ctor
-- @param self
-- 
function BagPartnerCell:ctor()
	BagPartnerCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagPartnerCell] _create
-- @param self
-- 
function BagPartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_xiake.ccbi", true)
	
	self:handleButtonEvent("onCcb.aBtn", self._onClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	self["nameLab"]:setVisible(false)
	
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self._layer = display.newLayer()
	self._layer:setTouchEnabled(true)
	self._layer:addTouchEventListener(function(...) return self:_onTouch(...) end)
	self:addChild(self._layer)
	
	local EventCenter = require("utils.EventCenter")
	local PartnerEvents = require("model.event.PartnerEvents")
	EventCenter:addEventListener(PartnerEvents.PARTNER_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
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
-- @function [parent=#BagPartnerCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagPartnerCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 属性变化
-- @function [parent=#BagPartnerCell] _attrsUpdatedHandler
-- @param self
-- @param model.event.PartnerEvents#ATTRS_UPDATE event
-- 
function BagPartnerCell:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._partner  then return end
	if self._partner.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "War" then
			if v > 0 then
				self["onSpr"]:setVisible(true)
				self:changeFrame("onCcbSpr", "ccb/buttontitle/putoff.png")
			else
				self["onSpr"]:setVisible(false)
				self:changeFrame("onCcbSpr", "ccb/buttontitle/puton.png")
			end
		end
		
		if k == "Star" then
			for i = 1 , 7 do
				if i > v then
					self:changeFrame("star" .. i .. "Spr", "ccb/mark/star_shadow.png")
				else
					self:changeFrame("star" .. i .. "Spr", "ccb/mark/star_yellow.png")
				end
			end
		end
		
		if k == "Score" then
			self["scoreLab"]:setString("" .. v )
		end
	end
end

---
-- 点击了上/下阵
-- @function [parent=#BagPartnerCell] _onClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event
-- 
function BagPartnerCell:_onClkHandler( sender, event )
	if not self._partner or not self._partner.Id then return end
	
	if self._partner.War > 0 then 
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_partner_set_fight", { id = self._partner.Id, iswar = 0})
		return
	end
	
	local PartnerData = require("model.PartnerData")
	local cnt = PartnerData.getWarPartnerCount()
	local HeroAttr = require("model.HeroAttr")
	if self._partner.War == 0 and cnt < HeroAttr.MaxFightPartnerCnt then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_partner_set_fight", {id = self._partner.Id, iswar = 1, pos = 0})
	else
		self:openWarPartnerSelectView()
	end
end

---
-- 打开出战同伴选择界面
-- @function [parent=#BagPartnerCell] openWarPartnerSelectView
-- @param self
-- 
function BagPartnerCell:openWarPartnerSelectView()
	local PartnerData = require("model.PartnerData")
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	local arr =  PartnerData.warPartnerSet:getArray()
	local Partner = require("model.Partner")
	for k, v in pairs(arr) do
		if( v and v.War > 0 ) then
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
			obj["isReplace"] = true -- 是否是替换上阵
			
 			dataset:addItem( obj )
		end
	end
	
	local PartnerSelectView = require("view.partner.PartnerSelectView")
	local GameView = require("view.GameView")
	GameView.addPopUp(PartnerSelectView.createInstance(), true)
	PartnerSelectView.instance:showPartner(dataset, 0, self._partner.Id)
end

--- 
-- 显示数据
-- @function [parent=#BagPartnerCell] showItem
-- @param self
-- @param model.Partner#Partner partner 道具
-- 
function BagPartnerCell:showItem( partner )
	self._partner = partner
	
	if( not partner ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
--		self._layer:setTouchEnabled(false)

		self:changeTexture("itemCcb.starBgSpr", nil)
		self:changeTexture("itemCcb.typeBgSpr", nil)
		self:changeTexture("itemCcb.typeSpr", nil)
		return
	end
	
	-- 是否是假道具(没有道具补全界面用到)
	if partner.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["nameText"]:setVisible(false)
--		self._layer:setTouchEnabled(false)
		return
	end
	
--	self._layer:setTouchEnabled(true)
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	if partner.Step == 0 then
		partner.Step = 1
	end
	self:_setText("nameText", partner.Name, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
	self["nameText"]:setVisible(true)
--	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step]..(partner.Name or ""))
	self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[partner.Step])
	self["lvLab"]:setString( "" .. (partner.Grade or "0") .. "级" )
	self["itemCcb.lvLab"]:setString( "" )
	self["itemCcb.headPnrSpr"]:showIcon(partner.Photo)
	self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	
	self["scoreLab"]:setString("" .. (partner.Score or "0") )
	
	local types = {tr("进攻型"),tr("防守型"),tr("均衡型"),tr("内力狂人")}
	self["typeLab"]:setString(types[partner.Type])
	
	local star = partner.Star or 0
	local canUpStar = partner.CanUpStarNum or 0
	local sprName
	for i=1, 7 do
		sprName = "star" .. i .. "Spr"
		if(i<=star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>star and i<=canUpStar) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
		end
	end
	
	if partner.War > 0 then
		self["onSpr"]:setVisible( true )
		self:changeFrame("onCcbSpr", "ccb/buttontitle/putoff.png")
	else
		self["onSpr"]:setVisible( false )
		self:changeFrame("onCcbSpr", "ccb/buttontitle/puton.png")
	end
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["itemCcb.starBgSpr"]:setVisible(true)
		self["itemCcb.starLab"]:setVisible(true)
		self["itemCcb.typeBgSpr"]:setVisible(true)
		self["itemCcb.starLab"]:setString(partner.Star)
		self:changeFrame("itemCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["itemCcb.typeSpr"]:setPosition(92,26)
	else
		self["itemCcb.starBgSpr"]:setVisible(false)
		self["itemCcb.starLab"]:setVisible(false)
		self["itemCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("itemCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["itemCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("itemCcb.starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("itemCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["itemCcb.typeSpr"]:setVisible(true)
end


---
-- ui点击处理
-- @function [parent=#BagPartnerCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagPartnerCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._partner ) then return end
	if self._partner.isFalse then return end
	
	local func = function()
		local BagPartnerInfoUi = require("view.bag.BagPartnerInfoUi")
		BagPartnerInfoUi.createInstance():openUi(self._partner)
	end
	
	local action = transition.sequence({
		CCScaleTo:create(0.05, 1.5),
		CCEaseBounceOut:create(CCScaleTo:create(0.2, 1.0)),
		CCCallFunc:create(func)
	})
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self["itemCcb"]:runAction(action)
end

---
-- 清理事件
-- @function [parent=#BagPartnerCell] onCleanup
-- 
function BagPartnerCell:onCleanup()
	local EventCenter = require("utils.EventCenter")
	local PartnerEvents = require("model.event.PartnerEvents")
	EventCenter:removeEventListener(PartnerEvents.PARTNER_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	BagPartnerCell.super.onCleanup(self)
end

---
-- 获取侠客信息
-- @function [parent=#BagPartnerCell] getItem
-- @param self
-- @return model.Partner#Partner
-- 
function BagPartnerCell:getItem()
	return self._partner
end

---
-- 触摸事件处理
-- @function [parent=#BagPartnerCell] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
--
function BagPartnerCell:_onTouch(event,x,y)
	if event == "began" then
		return self:_onTouchBegan(x, y)
	elseif event == "moved" then
		self:_onTouchMoved(x, y)
	elseif event == "ended" then
		self:_onTouchEnded(x, y)
	end
end

---
-- 触摸开始
-- @function [parent=#BagPartnerCell] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
--
function BagPartnerCell:_onTouchBegan(x,y)
	if not self._partner or self._partner.isFalse then return false end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		self["itemCcb"]:setScale(1.5)
		return true
	end
end

---
-- 触摸移动
-- @function [parent=#BagPartnerCell] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
--
function BagPartnerCell:_onTouchMoved(x,y)
end

---
-- 触摸结束
-- @function [parent=#BagPartnerCell] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
--
function BagPartnerCell:_onTouchEnded(x,y)
	self["itemCcb"]:setScale(1.0)
	
	if not self._partner or self._partner.isFalse then return end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		local func = function()
			if self._partner and not self._partner.isFalse then
				local BagPartnerInfoUi = require("view.bag.BagPartnerInfoUi")
				BagPartnerInfoUi.createInstance():openUi(self._partner)
			end
		end
		
		local action = transition.sequence({
			CCScaleTo:create(0.05, 1.5),
			CCEaseBounceOut:create(CCScaleTo:create(0.2, 1.0)),
			CCCallFunc:create(func)
		})
		self["itemCcb"]:runAction(action)
	end
end

