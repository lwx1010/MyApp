---
-- 可用积分兑换的道具
-- @module view.biwu.BWItemCell
--

local require = require
local class = class
local printf = printf
local tr = tr
local tonumber = tonumber


local moduleName = "view.biwu.BWItemCell"
module(moduleName)


--- 
-- 类定义
-- @type BWItemCell
-- 
local BWItemCell = class(moduleName, require("ui.CCBView").CCBView)


---
-- 道具
-- @field [parent=#BWItemCell] #Biwu_shop(协议生成) _item
BWItemCell._item = nil

--- 创建实例
-- @return BWItemCell实例
function new()
	return BWItemCell.new()
end

---
-- 构造函数
-- @function [parent = #BWItemCell] ctor
-- 
function BWItemCell:ctor()
	BWItemCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWItemCell] _create
-- 
function BWItemCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkexchangecontent.ccbi", true)
	
	self:handleButtonEvent("addBtn", self._addClkHandler)
	self:handleButtonEvent("subBtn", self._subClkHandler)
	self:handleButtonEvent("exchangeBtn", self._exchangeClkHandler)
end

---
-- 点击了加
-- @function [parent=#BWItemCell] _addClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BWItemCell:_addClkHandler( sender, event )
	local cnt = tonumber(self["cntLab"]:getString())
	cnt = cnt + 1
	self["cntLab"]:setString("" .. cnt )
	self["tipLab"]:setString(tr("共需") .. (self._item.shop_jifen*cnt) .. tr("积分"))
end

---
-- 点击了减
-- @function [parent=#BWItemCell] _subClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BWItemCell:_subClkHandler( sender, event )
	local cnt = tonumber(self["cntLab"]:getString())
	if cnt == 1 then return end
	
	cnt = cnt - 1 
	self["cntLab"]:setString("" .. cnt )
	self["tipLab"]:setString(tr("共需") .. (self._item.shop_jifen*cnt) .. tr("积分"))
end

---
-- 点击了兑换
-- @function [parent=#BWItemCell] _exchangeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BWItemCell:_exchangeClkHandler( sender, event )
	local cnt = tonumber(self["cntLab"]:getString())
	local score = cnt * self._item.shop_jifen
	local HeroAttr = require("model.HeroAttr")
	
	if (HeroAttr.BiWuJiFen or 0) < score then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("积分不足，无法兑换！"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_biwu_shop_buy", {shop_no = self._item.shop_no, shop_kind = self._item.shop_kind, buy_num = cnt})
end

---
-- 显示道具信息
-- @function [parent=#BWItemCell] showItem
-- @param self
-- @param #table item
-- 
function BWItemCell:showItem( item )
	self._item = item
	
	if not item then
		self:changeTexture("itemCcb.headPnrSpr", nil)
		self:changeFrame("itemCcb.frameSpr", nil)
		self:changeFrame("itemCcb.lvBgSpr", nil)
		return
	end
	
	-- 是否是真道具(没有道具补全界面用到)
	if item.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeItemIcon("itemCcb.headPnrSpr", item.shop_icon)
	self:changeFrame("itemCcb.frameSpr", nil)
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["nameLab"]:setString(item.shop_name)
	self["cntLab"]:setString("1")
	self["tipLab"]:setString(tr("共需") .. item.shop_jifen .. tr("积分"))
end

---
-- ui点击处理
-- @function [parent=#BWItemCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BWItemCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	
end

---
-- 获取道具信息
-- @function [parent=#BWItemCell] getItem
-- @param self
-- @return #Biwu_shop(协议生成) 
-- 
function BWItemCell:getItem()
	return self._item
end

