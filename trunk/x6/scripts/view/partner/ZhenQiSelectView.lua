--- 
-- 选择真气界面
-- @module view.partner.ZhenQiSelectView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local table = table


local moduleName = "view.partner.ZhenQiSelectView"
module(moduleName)

--- 
-- 类定义
-- @type ZhenQiSelectView
-- 
local ZhenQiSelectView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 确定回调函数
-- @field [parent=#ZhenQiSelectView] #function _confirmCallback
-- 
ZhenQiSelectView._confirmCallback = nil

---
-- 选中的对象
-- @field [parent=#ZhenQiSelectView] #table _selectObj
-- 
ZhenQiSelectView._selectObj = nil

---
-- 调用本对象的界面
-- @field @field [parent=#ZhenQiSelectView] ui.CCBView#CCBView _view
--
ZhenQiSelectView._view = nil

---
-- 额外参数
-- @field [parent=#ZhenQiSelectView] #number _extdata
-- 
ZhenQiSelectView._extdata = nil

--- 
-- 构造函数
-- @function [parent=#ZhenQiSelectView] ctor
-- @param self
-- 
function ZhenQiSelectView:ctor()
	ZhenQiSelectView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ZhenQiSelectView] _create
-- @param self
-- 
function ZhenQiSelectView:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_publicselection.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local objsBox = self["itemsPCBox"] -- ui.PageCellBox#PageCellBox
--	objsBox:setVSpace(8)
	objsBox:setVCount(1)
	objsBox:setHCount(4)
	objsBox:setHSpace(8)
	local ZhenQiCell = require("view.partner.sub.ZhenQiCell")
	objsBox.owner = self
	objsBox:setCellRenderer(ZhenQiCell)
	
	local ZhenQiData = require("model.ZhenQiData")
	local set = ZhenQiData.canEquipZhenQiSet
	objsBox:setDataSet(set)
	
	local ScrollView = require("ui.ScrollView")
	objsBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 关闭界面
-- @function [parent=#ZhenQiSelectView] clkHandler
-- @param self
-- 
function ZhenQiSelectView:closeView()
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了关闭
-- @function [parent=#ZhenQiSelectView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ZhenQiSelectView:_closeClkHandler( sender, event )
	self:closeView()
end

---
-- 设置真气装备信息
-- @function [parent=#ZhenQiSelectView] showItem
-- @param self
-- @param #number pos 装备位置
-- @param #number partnerID 同伴id
-- @param #table changeZhenQi 要替换的旧真气，如果是直接装备真气，则不用传入
-- 
function ZhenQiSelectView:showItem(pos, partnerID, changeZhenQi)
	self._pos = pos
	self._partnerID = partnerID
	
	if(changeZhenQi) then
		self._changeZhenQi = changeZhenQi
	else
		self._changeZhenQi = false
	end
	
	self["zhenRongSpr"]:setVisible(false)
	self["martialSpr"]:setVisible(false)
	self["partnerSpr"]:setVisible(false)
	self["equipSpr"]:setVisible(false)
	self["zhenQiSpr"]:setVisible(true)
end

---
-- 显示真气列表
-- @function [parent=#ZhenQiSelectView] showZhenQiList
-- @param self
-- 
function ZhenQiSelectView:showZhenQiList()
	local ZhenQiData = require("model.ZhenQiData")
	local set = ZhenQiData.canEquipZhenQiSet
	local arrs = set:getArray()
	-- 按品质进行排序
	local func = function(a, b)
		return a.Quality > b.Quality
	end
	table.sort(arrs, func)
	
	local len = set:getLength()
	local left = len%4
	if len == 0 or left > 0 then
		for i = 1, 4-left do
			local zhenQi = {}
			zhenQi.isFalse = true
			set:addItem(zhenQi)
		end
	end
	
	local objsBox = self["itemsPCBox"] -- ui.CellBox#CellBox
	objsBox:setDataSet(set)
end

---
-- 获取要替换的真气
-- @function [parent=#ZhenQiSelectView] getChangeZhenQi
-- @param self
function ZhenQiSelectView:getChangeZhenQi()
	return self._changeZhenQi
end

---
-- 获取同伴运行id
-- @function [parent=#ZhenQiSelectView] getPartnerID
-- @param self
-- @return #number 
-- 
function ZhenQiSelectView:getPartnerID()
	return self._partnerID
end

---
-- 获取真气装备位置
-- @function [parent=#ZhenQiSelectView] getPos
-- @param self
-- @return #number 
-- 
function ZhenQiSelectView:getPos()
	return self._pos
end

---
-- 拖动
-- @function [parent=#ZhenQiSelectView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function ZhenQiSelectView:_scrollChangedHandler( event )
	if event == nil then return end
	
	local objsBox = self["itemsPCBox"] -- ui.PageCellBox#PageCellBox
	local width = objsBox:getSnapWidth()
	local dataSet = objsBox:getDataSet()
	local len = 0
	if dataSet then 
		len = dataSet:getLength()
	end
	
	local max = math.ceil(len/ 4)
	local index = 0
	if width > 0 then
		index = math.floor(( 0 - event.curX )/width) + 1
	end
	
	if index < 1 then index = 1 end
	if index > max then index = max end
	
	self["pageCcb.pageLab"]:setString( index .. "/" .. max )
end

---
-- 退出界面调用
-- @function [parent=#ZhenQiSelectView] onExit
-- @param self
-- 
function ZhenQiSelectView:onExit()
	local ScrollView = require("ui.ScrollView")
	self["itemsPCBox"]:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	ZhenQiSelectView.super.onExit(self)
end
