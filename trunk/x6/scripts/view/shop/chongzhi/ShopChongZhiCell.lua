---
-- 充值子项
-- @module view.shop.chongzhi.ShopChongZhiCell
--

local require = require
local class = class
local tr = tr
local printf = printf

local dump = dump

local moduleName = "view.shop.chongzhi.ShopChongZhiCell"
module(moduleName)

---
-- 类定义
-- @type ShopChongZhiCell
--
local ShopChongZhiCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 信息
-- @field [parent=#view.shop.chongzhi.ShopChongZhiCell] #table _msg
-- 
ShopChongZhiCell._msg = nil

---
-- 新建一个实例
-- @function [parent = #view.shop.chongzhi.ShopChongZhiCell] new
-- 
function new()
	return ShopChongZhiCell.new()
end

---
-- 构造函数
-- @function [parent = #ShopChongZhiCell] ctor
--
function ShopChongZhiCell:ctor()
	ShopChongZhiCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopChongZhiCell] _create
--
function ShopChongZhiCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_charge_piece.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(self)
end 

---
-- 显示内容
-- @function [parent = #ShopChongZhiCell] showItem
-- 
function ShopChongZhiCell:showItem(msg)
	if msg then
		self["yuanbaoLab"]:setString(msg.YuanBao..tr("元宝"))
		self["addLab"]:setString(msg.ExtraGive..tr("元宝"))
		self["chongZhiRmbLab"]:setString(msg.ChongZhiRmb)
		
		--显示对应图片
		local imageName = "one"
		if msg.SortNo == 1 then
			imageName = "one"
		elseif msg.SortNo == 2 then
			imageName = "two"
		elseif msg.SortNo == 3 then
			imageName = "three"
		elseif msg.SortNo == 4 then
			imageName = "four"
		elseif msg.SortNo == 5 then
			imageName = "five"
		elseif msg.SortNo == 6 then
			imageName = "six"
		end
		self:changeFrame("chongZhiLevelSpr", "ccb/shop/"..imageName..".png")
	end
	
	self._msg = msg
end

---
-- 点击回调
-- @function [parent = #ShopChongZhiCell] uiClkHandler
-- 
function ShopChongZhiCell:uiClkHandler(ui, rect)
	if not self._msg then return end
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openPayView(self._msg.ChongZhiRmb, self._msg.YuanBao)
end








