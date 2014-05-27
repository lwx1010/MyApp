--- 
-- 武学cell
-- @module view.role.MartialCell
-- 

local class = class
local require = require
local tr = tr
local printf = printf

local moduleName = "view.role.MartialCell"
module(moduleName)

--- 
-- 类定义
-- @type MartialCell
-- 
local MartialCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- item
-- @field [parent=#MartialCell] _item
-- 
MartialCell._item = nil

---
-- 创建实例
-- @return MartialCell实例
-- 
function new()
	return MartialCell.new()
end

--- 
-- 构造函数
-- @function [parent=#MartialCell] ctor
-- @param self
-- 
function MartialCell:ctor()
	MartialCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#MartialCell] _create
-- @param self
-- 
function MartialCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_biguan_card.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示内容
-- @function [parent=#MartialCell] showItem
-- @param self
-- @param #table item
-- 
function MartialCell:showItem(item)
	if not item then return end
	
	self._item = item
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
	
	self:changeItemIcon("partnerCcb.headPnrSpr", item.IconNo)
	self:changeFrame("partnerCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])
	self:changeFrame("partnerCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[item.Rare])
	self["partnerCcb.lvLab"]:setString("" .. item.MartialLevel)
	
--	if item.isSelected then
--		self:setGraySprite(self["partnerCcb.headPnrSpr"])
--		self:setGraySprite(self["partnerCcb.frameSpr"])
--	else
--		self:restoreSprite(self["partnerCcb.headPnrSpr"])
--		self:restoreSprite(self["partnerCcb.frameSpr"])
--	end
end

---
-- 获取item
-- @function [parent=#MartialCell] getItem
-- @param self
-- @return #table
-- 
function MartialCell:getItem()
	return self._item
end

---
-- 恢复颜色
-- @function [parent=#MartialCell] restore
-- @param self
-- 
--function MartialCell:restore()
--	self:restoreSprite(self["partnerCcb.headPnrSpr"])
--	self:restoreSprite(self["partnerCcb.frameSpr"])
--	if self._item then
--		self._item.isSelected = false
--	end
--end

---
-- ui点击处理
-- @function [parent=#MartialCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function MartialCell:uiClkHandler( ui, rect )
	if (not self.owner) or (not self.owner.owner) then return end
	
	self.owner.owner:setSelectedItem(self)
end