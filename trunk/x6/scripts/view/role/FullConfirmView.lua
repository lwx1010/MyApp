--- 
-- 确认
-- @module view.role.FullConfirmView
-- 

local class = class
local require = require
local tr = tr
local ipairs = ipairs
local table = table
local printf = printf

local moduleName = "view.role.FullConfirmView"
module(moduleName)

--- 
-- 类定义
-- @type FullConfirmView
-- 
local FullConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 上次选中单元
-- @field [parent=#FullConfirmView] #CCSprite _lastSelectedItem
-- 
FullConfirmView._lastSelectedItem = nil

---
-- 子字符串
-- @field [parent=#FullConfirmView] #string _subStr
-- 
FullConfirmView._subStr = nil

---
-- name
-- @field [parent=#FullConfirmView] #string _name
--
FullConfirmView._name = nil

---
-- 创建实例
-- @return FullConfirmView实例
-- 
function new()
	return FullConfirmView.new()
end

--- 
-- 构造函数
-- @function [parent=#FullConfirmView] ctor
-- @param self
-- 
function FullConfirmView:ctor()
	FullConfirmView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FullConfirmView] _create
-- @param self
-- 
function FullConfirmView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_canwupiece1.ccbi", true)
	
	self:handleButtonEvent("okCcb.aBtn", self._okClkHandler)
	self:handleButtonEvent("cancelCcb.aBtn", self._cancelClkHandler)
	
	self:createClkHelper()
	for i = 1, 4 do
		self:addClkUi("backSpr" .. i)
	end
end

--- 
-- 点击了确认
-- @function [parent=#FullConfirmView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FullConfirmView:_okClkHandler( sender, event )
    local GameNet = require("utils.GameNet")
    GameNet.send("C2s_buff_change", {change_name = self._name})
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self)
end

--- 
-- 点击了取消
-- @function [parent=#FullConfirmView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FullConfirmView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self)
    
--    local UnderstandMartialView = require("view.role.UnderstandMartialView").instance
--    if UnderstandMartialView then
--    	UnderstandMartialView:getSubView():clearSelectedFrame()
--    end
end

---
-- 打开界面
-- @function [parent=#FullConfirmView] openUi
-- @param self
-- @param #table pb
--
function FullConfirmView:openUi(pb)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	if not pb then return end
	
	local UnderstandMartialSubView = require("view.role.UnderstandMartialSubView")
	for i = 1, 4 do
		UnderstandMartialSubView.handleAttr(pb.has_prop[i], true, true, true)
	end
	
	UnderstandMartialSubView.handleAttr(pb.now_prop, true, false, false)
	
	table.sort(pb.has_prop, function(a, b)
		return a.index < b.index
	end)
	
	local cor2 = "<c1>"
	
	for i = 1, 4 do
		self:changeFrame("iconSpr" .. i, pb.has_prop[i].frame)
		self["backSpr" .. i].info = pb.has_prop[i]
		self["backSpr" .. i].select = self["selectRectSpr" .. i]
		self["selectRectSpr" .. i]:setVisible(false)
		self["attrLab" .. i]:setString(cor2 .. tr(pb.has_prop[i].attr) .. "+" .. pb.has_prop[i].rate / 100 .. "%" .. "</c>")
	end
	
	local cor1 = "<c1>"
	local ItemViewConst = require("view.const.ItemViewConst")
--	if pb.now_prop.prop_name == "Hp" or pb.now_prop.prop_name == "Ap" or pb.now_prop.prop_name == "Dp" or pb.now_prop.prop_name == "Speed" then
--		cor1 = ItemViewConst.BUFF_COLOR_TABLE[pb.now_prop.rate / 100 - 15]
--	else
--		cor1 = ItemViewConst.BUFF_COLOR_TABLE[pb.now_prop.rate / 100 - 10]
--	end
	
	
	for i = 1, 4 do
		local item = pb.has_prop[i]
		
		if item.prop_name == "Hp" or item.prop_name == "Ap" or item.prop_name == "Dp" or item.prop_name == "Speed" then
			cor2 = ItemViewConst.BUFF_COLOR_TABLE[item.rate / 100 - 15]
		else
			cor2 = ItemViewConst.BUFF_COLOR_TABLE[item.rate / 100 - 10]
		end
		item.cor = cor2
	end
	
--	self._subStr = tr("您确定使用新的属性 ") .. cor1 .. tr(pb.now_prop.attr) .. " +" .. pb.now_prop.rate / 100 .. "%" .. "</c>" .. tr("替换已有属性吗?")
--	self["tipLab"]:setString(self._subStr .. tr(pb.has_prop[1].attr) .. pb.has_prop[1].cor .. " +" .. pb.has_prop[1].rate / 100 .. "%" .. "</c>" .. tr("吗？"))
	self["attrLab"]:setString(cor1 .. tr(pb.now_prop.attr) .. "+" .. pb.now_prop.rate / 100 .. "%" .. "</c>")
--	self["attrLab2"]:setString(tr(pb.has_prop[1].attr) .. pb.has_prop[1].cor .. " +" .. pb.has_prop[1].rate / 100 .. "%" .. "</c>")
--	self["attrLab"]:setString(self._subStr)
	self["selectRectSpr1"]:setVisible(true)
	self._lastSelectedItem = self["backSpr1"]
	
	self._name = pb.has_prop[1].prop_name
end

---
-- ui点击处理
-- @function [parent=#FullConfirmView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function FullConfirmView:uiClkHandler( ui, rect )
	if ui == self._lastSelectedItem then return end
	
	self._lastSelectedItem.select:setVisible(false)
	self._lastSelectedItem = ui
	ui.select:setVisible(true)
	
--	self["tipLab"]:setString(self._subStr .. tr(ui.info.attr) .. ui.info.cor .. " +" .. ui.info.rate / 100 .. "%" .. "</c>" .. tr("吗？"))
--	self["attrLab"]:setString(ui.info.cor .. tr(ui.info.attr) .. " +" .. ui.info.rate / 100 .. "%" .. "</c>")
	self._name = ui.info.prop_name
end

---
-- 退出界面时调用
-- @function [parent=#FullConfirmView] onExit
-- @param self
-- 
function FullConfirmView:onExit()
	instance = nil
	
	FullConfirmView.super.onExit(self)
end