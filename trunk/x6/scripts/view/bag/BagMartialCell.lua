--- 
-- 背包：武学cell
-- @module view.bag.BagMartialCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local string = string
local ui = ui
local ccp = ccp
local transition = transition
local CCEaseBounceOut = CCEaseBounceOut
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc
local CCRect = CCRect
local display = display


local moduleName = "view.bag.BagMartialCell"
module(moduleName)

--- 
-- 类定义
-- @type BagMartialCell
-- 
local BagMartialCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#BagMartialCell] model.Item#Item _item
-- 
BagMartialCell._item = nil

--- 创建实例
-- @return BagMartialCell实例
function new()
	return BagMartialCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagMartialCell] ctor
-- @param self
-- 
function BagMartialCell:ctor()
	BagMartialCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagMartialCell] _create
-- @param self
-- 
function BagMartialCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_wugong.ccbi", true)
	
	self:handleButtonEvent("sellCcb.aBtn", self._sellClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	self["onSpr"]:setVisible(false)
	self["nameLab"]:setVisible(false)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	-- 创建描边文本
	self["ownerText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 247,
					}
				 )
	self["ownerText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["ownerText"])
	
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
	
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self._layer = display.newLayer()
	self._layer:setTouchEnabled(true)
	self._layer:addTouchEventListener(function(...) return self:_onTouch(...) end)
	self:addChild(self._layer)
end

---
-- 设置描边文字
-- @function [parent=#BagMartialCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagMartialCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 属性变化
-- @function [parent=#BagMartialCell] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagMartialCell:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "EquipPartnerId" then
--			self["onSpr"]:setVisible(v > 0)
			if v == 0 then
				self["ownerText"]:setVisible(false)
			else
				local PartnerData = require("model.PartnerData")
				local PartnerShowConst = require("view.const.PartnerShowConst")
				local partner = PartnerData.findPartner(v)
				if partner then
					self:_setText("ownerText", partner.Name, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
					self["ownerText"]:setVisible(true)
				end
			end
		end
		
		if k == "MartialLevel" then
			self["lvLab"]:setString("" .. v .. tr("级"))	
		end
		
		if k == "MartialSkillAp" then
			self["powerLab"]:setString("<c1> + " .. v )
		end
	end
end

---
-- 点击了出售
-- @function [parent=#BagMartialCell] _sellClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagMartialCell:_sellClkHandler( sender, event )
	if not self._item then return end
	
	if self._item.EquipPartnerId and self._item.EquipPartnerId > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("正在使用的武学不能出售！！！"))
		return
	end
	
	local func = function()
			if self._item then
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_item_sell", {item_id = self._item.Id})
				local GameView = require("view.GameView")
				GameView.removePopUp(self)
			end
		end
	
	local tip = string.format(tr("是否确定出后%s可获得银两%s？"), self._item.Name, self._item.ShowPrice)
	local BagItemSellTipUi = require("view.bag.BagItemSellTipUi")
	BagItemSellTipUi.new():openUi(func, tip)
end

--- 
-- 显示数据
-- @function [parent=#BagMartialCell] showItem
-- @param self
-- @param model.Item#Item item 道具
-- 
function BagMartialCell:showItem( item )
	self._item = item
	
	if( not item ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	-- 是否是真道具(没有道具补全界面用到)
	if item.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["ownerText"]:setVisible(false)
		self["nameText"]:setVisible(false)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local PartnerData = require("model.PartnerData")
	local PartnerShowConst = require("view.const.PartnerShowConst")
	
	self:_setText("nameText", item.Name, ItemViewConst.MARTIAL_OUTLINE_COLORS[item.Rare])
	self["nameText"]:setVisible(true)
--	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
	self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[item.Rare])
	if item.EquipPartnerId and item.EquipPartnerId == 0 then
--		self["onSpr"]:setVisible(false)
		self["ownerText"]:setVisible(false)
	else
--		self["onSpr"]:setVisible(true)
		local partner = PartnerData.findPartner(item.EquipPartnerId)
		if partner then
			self:_setText("ownerText", partner.Name, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
			self["ownerText"]:setVisible(true)
		end
	end
	
	self["lvLab"]:setString("" .. item.MartialLevel .. tr("级"))	
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	-- 武学类型
	self["typeLab"]:setString(ItemViewConst.MARTIAL_TYPE[item.SubKind] .. tr("武学"))
	self["powerLab"]:setString(tr("<c1> + ") .. item.MartialSkillAp )
	
	if item.MartialSkillApTargetType then
		if item.MartialSkillApTargetType == 1 then
			self["rangeLab"]:setString(tr("<c1>一行"))
		elseif item.MartialSkillApTargetType == 2 then
			self["rangeLab"]:setString(tr("<c1>一列"))
		elseif item.MartialSkillApTargetType == 3 then
			self["rangeLab"]:setString(tr("<c1>全体"))
		else
			self["rangeLab"]:setString(tr("<c1>单体"))
		end
	else
		self["rangeLab"]:setString(tr("<c1>单体"))
	end
end


---
-- ui点击处理
-- @function [parent=#BagMartialCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagMartialCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	if self._item.isFalse then return end
	
	local func = function()
		local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
		BagMartialInfoUi.createInstance():openUi(self._item)
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
-- @function [parent=#BagMartialCell] onCleanup
-- 
function BagMartialCell:onCleanup()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	BagMartialCell.super.onCleanup(self)
end

---
-- 获取道具信息
-- @function [parent=#BagMartialCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function BagMartialCell:getItem()
	return self._item
end

---
-- 触摸事件处理
-- @function [parent=#BagMartialCell] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
--
function BagMartialCell:_onTouch(event,x,y)
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
-- @function [parent=#BagMartialCell] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
--
function BagMartialCell:_onTouchBegan(x,y)
	if not self._item or self._item.isFalse then return false end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		self["itemCcb"]:setScale(1.5)
		return true
	end
end

---
-- 触摸移动
-- @function [parent=#BagMartialCell] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
--
function BagMartialCell:_onTouchMoved(x,y)
end

---
-- 触摸结束
-- @function [parent=#BagMartialCell] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
--
function BagMartialCell:_onTouchEnded(x,y)
	self["itemCcb"]:setScale(1.0)
	
	if not self._item or self._item.isFalse then return end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		local func = function()
			if self._item and not self._item.isFalse then
				local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
				BagMartialInfoUi.createInstance():openUi(self._item)
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
