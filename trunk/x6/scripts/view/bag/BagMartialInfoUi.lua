--- 
-- 武学信息界面
-- @module view.bag.BagMartialInfoUi
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local string = string

local moduleName = "view.bag.BagMartialInfoUi"
module(moduleName)

--- 
-- 类定义
-- @type BagMartialInfoUi
-- 
local BagMartialInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武学道具
-- @field [parent=#BagMartialInfoUi] model.Item#Item _item
-- 
BagMartialInfoUi._item = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#BagMartialInfoUi] #boolean _canCtr
-- 
BagMartialInfoUi._canCtr = nil

--- 
-- 构造函数
-- @function [parent=#BagMartialInfoUi] ctor
-- @param self
-- 
function BagMartialInfoUi:ctor()
	BagMartialInfoUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagMartialInfoUi] _create
-- @param self
-- 
function BagMartialInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_wugonginfobox.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("sellCcb.aBtn", self._sellClkHandler)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化
-- @function [parent=#BagMartialInfoUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagMartialInfoUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "MartialDesc" then
			self["descLab"]:setString(v)
		end
	end
end

---
-- 点击了出售
-- @function [parent=#BagMartialInfoUi] _sellClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagMartialInfoUi:_sellClkHandler( sender, event )
	printf("clk sell")
	
	if not self._item then return end
	
	if self._item.EquipPartnerId > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("正在使用的武学不能出售！！！"))
		return
	end
	
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
-- @function [parent=#BagMartialInfoUi] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagMartialInfoUi:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BagMartialInfoUi] openUi
-- @param self
-- @param model.Item#Item item
-- @param #boolean canCtr
-- 
function BagMartialInfoUi:openUi( item, canCtr  )
	if not item then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self:showItemInfo(item)
	
	if canCtr == nil or canCtr == true then 
		self._canCtr = true
	else
		self._canCtr = false 
	end
	
	self["sellCcb"]:setVisible(self._canCtr)
	self["sellCcbSpr"]:setVisible(self._canCtr)
end


---
-- 显示武学信息
-- @function [parent=#BagMartialInfoUi] showMartialInfo
-- @param self
-- @param model.Item#Item martial
-- @param #boolean canCtr 
-- 
function BagMartialInfoUi:showItemInfo( martial )
	self._item = martial
	
	if not self._item then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeItemIcon("itemCcb.headPnrSpr", martial.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[martial.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[martial.Rare] ..  martial.Name)
	self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[martial.Rare])
	self["lvLab"]:setString("" .. martial.MartialLevel)
	self["stepLab"]:setString("" .. martial.MartialRealm)
	
	self["descLab"]:setString("")
	
	local GameNet = require("utils.GameNet")
	local keys = {"ShowMartialLevelMax", "MartialRealmMax", "MartialFitWeapon", "MartialDesc"}
	GameNet.send("C2s_item_baseinfo", {id = self._item.Id, key = keys})
	GameNet.send("C2s_item_martial_skill", {id = self._item.Id})
end

---
-- 显示武学招式信息
-- @function [parent=#BagMartialInfoUi] showSkillInfo
-- @param self
-- @param #number Id 武学Id
-- @param #table list 武学招式信息
-- 
function BagMartialInfoUi:showSkillInfo(id, list)
	if not self._item or self._item.Id ~= id then return end
	if not list then return end
	
	local index = 1
	local ItemViewConst = require("view.const.ItemViewConst")
	
	for i = 1, 2 do
		local v = list[i]
		if v and v.type > 0 then 
			self:changeFrame("attr".. i .. "Spr", ItemViewConst.MARTIAL_SKILL_TYPE[v.type])
			self["attr".. i .. "Lab"]:setString(v.des)
		else
			self:changeFrame("attr".. i .. "Spr", nil)
			self["attr".. i .. "Lab"]:setString("")
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#BagMartialInfoUi] onExit
-- @param self
-- 
function BagMartialInfoUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	BagMartialInfoUi.super.onExit(self)
end