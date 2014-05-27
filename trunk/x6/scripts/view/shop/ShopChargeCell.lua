---
-- 商城充值界面cell
-- @module view.shop.ShopChargeCell
--

local require = require
local class = class

local moduleName = "view.shop.ShopChargeCell"
module(moduleName)

---
-- 类定义
-- @type ShopChargeCell
-- 
local ShopChargeCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 新建一个实例
-- @function [parent - #view.shop.ShopChargeCell] new
-- 
function new()
	return ShopChargeCell.new()
end

---
-- 构造函数
-- @function [parent = #ShopChargeCell] ctor
-- 
function ShopChargeCell:ctor()
	ShopChargeCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopChargeCell] _create
-- 
function ShopChargeCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_charge_piece.ccbi", true)
end

---
-- 更新数据
-- @function [parent = #ShopItemCell] showItem
-- @param #table msg
-- 
function ShopChargeCell:showItem(msg)
end

