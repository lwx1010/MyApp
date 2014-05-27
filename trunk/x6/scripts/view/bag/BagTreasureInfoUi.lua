--- 
-- 宝物信息界面
-- @module view.bag.BagTreasureInfoUi
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local string = string
local tonumber = tonumber

local moduleName = "view.bag.BagTreasureInfoUi"
module(moduleName)

--- 
-- 类定义
-- @type BagTreasureInfoUi
-- 
local BagTreasureInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#BagTreasureInfoUi] model.Item#Item _item
-- 
BagTreasureInfoUi._item = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#BagTreasureInfoUi] #boolean _canCtr
-- 
BagTreasureInfoUi._canCtr = nil

--- 
-- 构造函数
-- @function [parent=#BagTreasureInfoUi] ctor
-- @param self
-- 
function BagTreasureInfoUi:ctor()
	BagTreasureInfoUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagTreasureInfoUi] _create
-- @param self
-- 
function BagTreasureInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_baowuinfobox.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("useCcb.aBtn", self._useClkHandler)
	self:handleButtonEvent("sellCcb.aBtn", self._sellClkHandler)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#BagTreasureInfoUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagTreasureInfoUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "ShowMartialLevelMax" then
			self["martialLvLab"]:setString( self._martial.MartialLevel .. "/" .. v .. tr("级") )
		end
		
		if k == "Amount" then
			if v == 0 then
				local GameView = require("view.GameView")
				GameView.removePopUp(self, true)
			else
				self["cntLab"]:setString("" .. v)
			end
		end
	end
end

--- 
-- 点击了使用
-- @function [parent=#BagTreasureInfoUi] _useClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagTreasureInfoUi:_useClkHandler( sender, event )
	if not self._item then return end
	
	local ItemConst = require("model.const.ItemConst")
	local HeroAttr = require("model.HeroAttr")
	-- 更名令
	if self._item.ItemNo == ItemConst.ITEMNO_GAIMINGLING then 
		local ChangeNameView = require("view.treasure.ChangeNameView")
		ChangeNameView.createInstance():openUi(self._item)
		return
	end
	
	-- 大还丹和小还丹
	if self._item.ItemNo == ItemConst.ITEMNO_DAHUANDAN or self._item.ItemNo == ItemConst.ITEMNO_XIAOHUANDAN then
		local ItemUsePartnerView = require("view.treasure.ItemUsePartnerView")
		ItemUsePartnerView.createInstance():openUi(self._item)
		return
	end
	
	-- 秘籍匣、装备匣
	if self._item.ItemNo >= 9000003 and self._item.ItemNo <= 9000024 then
		local str = self["cntLab"]:getString()
		local num = tonumber(str)
		-- 数量大于10，弹出批量使用界面
		if num >= 10 then
			local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
			ItemBatchUseView.createInstance():setShowMsg(self._item, HeroAttr.Id)
			return
		end
	end
	
	-- 奇珍袋、矿石袋
	if self._item.ItemNo == ItemConst.ITEMNO_QIZHENDAI or self._item.ItemNo == ItemConst.ITEMNO_KUANGSHIBAO then
		local str = self["cntLab"]:getString()
		local num = tonumber(str)
		-- 数量大于10，弹出批量使用界面
		if num >= 10 then
			local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
			ItemBatchUseView.createInstance():setShowMsg(self._item, HeroAttr.Id)
			return
		end
	end
	
	-- 目前宝物使用对象，默认都是hero
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_use", {char_id = HeroAttr.Id, item_id = self._item.Id})
end

--- 
-- 点击了出售
-- @function [parent=#BagTreasureInfoUi] _sellClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagTreasureInfoUi:_sellClkHandler( sender, event )
	local func = function()
			if self._item then
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_item_sell", {item_id = self._item.Id})
				local GameView = require("view.GameView")
				GameView.removePopUp(self, true)
			end
		end
	
	local tip = string.format(tr("是否确定出后%s可获得银两%s？"), self._item.Name, self._item.ShowPrice)
	local BagItemSellTipUi = require("view.bag.BagItemSellTipUi")
	BagItemSellTipUi.new():openUi(func, tip)
end

--- 
-- 点击了关闭
-- @function [parent=#BagTreasureInfoUi] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagTreasureInfoUi:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BagTreasureInfoUi] openUi
-- @param self
-- @param model.Item#Item item
-- 
function BagTreasureInfoUi:openUi( item )
	if not item then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	if item.CanUse then
		self:showBtn("useCcb", item.CanUse == 1)
		self["useCcb.aBtn"]:setVisible(item.CanUse == 1)
	else
		self:showBtn("useCcb", false)
		self["useCcb.aBtn"]:setVisible(false)
	end
	
	self:showItemInfo(item)
end

---
-- 显示宝物信息
-- @function [parent=#BagTreasureInfoUi] showItemInfo
-- @param self
-- @param model.Item#Item item
-- @param #boolean canCtr 
-- 
function BagTreasureInfoUi:showItemInfo( item, canCtr )
	self._item = item
	
	if not self._item then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
	self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[item.Rare])
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["descLab"]:setString(item.Info1 or "")
	
	self["needGradeLab"]:setString("" .. item.NeedGrade)
	self["cntLab"]:setString("" .. item.Amount)
end

---
-- 退出界面调用
-- @function [parent=#BagTreasureInfoUi] onExit
-- @param self
-- 
function BagTreasureInfoUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	BagTreasureInfoUi.super.onExit(self)
end