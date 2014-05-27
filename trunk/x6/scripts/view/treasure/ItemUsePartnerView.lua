---
-- 选择侠客使用道具界面
-- @module view.treasure.ItemUsePartnerView
--

local require = require
local class = class
local printf = printf
local tr = tr
local tonumber = tonumber


local moduleName = "view.treasure.ItemUsePartnerView"
module(moduleName)


--- 
-- 类定义
-- @type ItemUsePartnerView
-- 
local ItemUsePartnerView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前选中的大还丹道具
-- @field [parent=#ItemUsePartnerView] model.Item#Item _selectItem
-- 
ItemUsePartnerView._selectItem = nil


---
-- 构造函数
-- @function [parent = #ItemUsePartnerView] ctor
-- 
function ItemUsePartnerView:ctor()
	ItemUsePartnerView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 创建加载ccbi文件
-- @function [parent = #ItemUsePartnerView] _create
-- 
function ItemUsePartnerView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_itemuse/ui_item_dhd.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeWindowHandler)
	self:handleButtonEvent("name1Btn", self._btnClkHander)
	self:handleButtonEvent("name2Btn", self._btnClkHander)
	self:handleButtonEvent("name3Btn", self._btnClkHander)
	self:handleButtonEvent("name4Btn", self._btnClkHander)
	self:handleButtonEvent("name5Btn", self._btnClkHander)
	self:handleButtonEvent("name6Btn", self._btnClkHander)
end


--- 
-- 点击了侠客
-- @function [parent=#ItemUsePartnerView] _btnClkHander
-- @param self
-- @param #CCNode sender            
-- @param #table event
-- 
function ItemUsePartnerView:_btnClkHander( sender, event )
	if not event.data then
		return
	end
	
	local GameNet = require("utils.GameNet")
	local HeroAttr = require("model.HeroAttr")
	-- 数量大于10，弹出批量使用界面
	if self._selectItem.Amount >= 10 then
		local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
		ItemBatchUseView.createInstance():setShowMsg(self._selectItem, tonumber(event.data))
	else
		GameNet.send("C2s_item_use", {char_id = tonumber(event.data), item_id = self._selectItem.Id})
	end
	self:_closeWindowHandler()
end

---
-- 关闭窗口 按钮回调事件
-- @function [parent = #ItemUsePartnerView] _closeWindowHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ItemUsePartnerView:_closeWindowHandler(sender, event)
    local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#ItemUsePartnerView] openUi
-- @param self
-- @param model.Item#Item item
-- 
function ItemUsePartnerView:openUi( item )
	if not item then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._selectItem = item
	
	self:showCurWarPartners()
end

---
-- 显示出战侠客
-- @function [parent=#ItemUsePartnerView] showCurWarPartners
-- @param self
-- 
function ItemUsePartnerView:showCurWarPartners()
	local index = 1
	
	local PartnerData = require("model.PartnerData")
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local warpartnerarr = PartnerData.warPartnerSet:getArray()
	for i = 1, PartnerData.MAX_WARER do
		local partner = warpartnerarr[i]
		if partner then
			self["name" .. index .. "Lab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
			self["name" .. index .. "Btn"].data = partner.Id
			self["name" .. index .. "Btn"]:setEnabled(true)
			self["name" .. index .. "Btn"]:setVisible(true)
			index = index + 1
		end
	end
	
	for i = index, PartnerData.MAX_WARER do
		self["name" .. i .. "Lab"]:setString("")
		self["name" .. i .. "Btn"].data = nil
		self["name" .. i .. "Btn"]:setEnabled(false)
		self["name" .. i .. "Btn"]:setVisible(false)
	end
end

---
-- 退出界面调用
-- @function [parent=#ItemUsePartnerView] onExit
-- @param self
-- 
function ItemUsePartnerView:onExit()
	instance = nil
	ItemUsePartnerView.super.onExit(self)
end

