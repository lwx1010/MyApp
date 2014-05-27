---
-- 见闻录物品(侠客、武功、神兵)子项
-- @module view.jianwenlu.ItemCell
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.jianwenlu.ItemCell"
module(moduleName)

---
-- 类定义
-- @type ItemCell
-- 
local ItemCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 物品信息
-- @field [parent=#ItemCell] #table _item 
-- 
ItemCell._item = nil

---
-- 创建实例
-- @return #ItemCell
-- 
function new()
	return ItemCell.new()
end

---
-- 构造函数
-- @function [parent=#ItemCell] ctor
-- @param self
-- 
function ItemCell:ctor()
	ItemCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ItemCell] _create
-- @param self
-- 
function ItemCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jwpiece4.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("bgSpr")
end

---
-- 显示数据
-- @function [parent=#ItemCell] showItem
-- @param self
-- @param #table item 物品信息
-- 
function ItemCell:showItem(item)
	self._item = item
	
	if( not item ) then
		self:changeTexture("itemCcb.headPnrSpr", nil)	
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.bgSpr", nil)
		self["nameLab"]:setString("<c6>?")
		
		self:changeTexture("typeBgSpr", nil)
		self:changeTexture("typeSpr", nil)
		return
	end
	
	local view = self.owner.owner
	local index = view:getIndex()
	-- 侠客
	if( index == 1 ) then
		local PartnerShowConst = require("view.const.PartnerShowConst")
		self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[item.rare])
		self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[item.rare]..item.item_name)
		self["itemCcb.headPnrSpr"]:showIcon(item.item_photo)
		
		self["typeBgSpr"]:setVisible(true)
		self["typeSpr"]:setVisible(true)
		self:changeFrame("typeBgSpr", PartnerShowConst.STEP_ICON1[item.rare])
		self:changeFrame("typeSpr", PartnerShowConst.STEP_TYPE[item.partner_type])
	-- 武功
	elseif( index == 2 ) then
		local ItemViewConst = require("view.const.ItemViewConst")
		self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.rare])
		self["nameLab"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[item.rare]..item.item_name)
		self["itemCcb.headPnrSpr"]:showReward("item", item.item_photo)
		
		self["typeBgSpr"]:setVisible(false)
		self["typeSpr"]:setVisible(false)
	-- 装备
	elseif( index == 3 ) then
		-- 神兵
		if( item.rare == 5 ) then
			self:changeFrame("itemCcb.frameSpr", "ccb/mark/boxborder_red.png")
			self["nameLab"]:setString("<c5>"..item.item_name)
		else
			local ItemViewConst = require("view.const.ItemViewConst")
			self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.rare])
			self["nameLab"]:setString(ItemViewConst.EQUIP_STEP_COLORS[item.rare]..item.item_name)
		end
		self["itemCcb.headPnrSpr"]:showReward("item", item.item_photo)
		
		self["typeBgSpr"]:setVisible(false)
		self["typeSpr"]:setVisible(false)
	end
end

---
-- ui点击处理
-- @function [parent=#ItemCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ItemCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	
	local view = self.owner.owner
	view:requireItemInfo(self._item)	
end
















