--- 
-- 确认
-- @module view.role.ConfirmView
-- 

local class = class
local require = require
local tr = tr
local ipairs = ipairs
local printf = printf

local moduleName = "view.role.ConfirmView"
module(moduleName)

--- 
-- 类定义
-- @type ConfirmView
-- 
local ConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- name
-- @field [parent=#ConfirmView] #string _name
--
ConfirmView._name = nil

---
-- 创建实例
-- @return ConfirmView实例
-- 
function new()
	return ConfirmView.new()
end

--- 
-- 构造函数
-- @function [parent=#ConfirmView] ctor
-- @param self
-- 
function ConfirmView:ctor()
	ConfirmView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ConfirmView] _create
-- @param self
-- 
function ConfirmView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_canwupiece2.ccbi", true)
	
	self:handleButtonEvent("okCcb.aBtn", self._okClkHandler)
	self:handleButtonEvent("cancelCcb.aBtn", self._cancelClkHandler)
end

--- 
-- 点击了确认
-- @function [parent=#ConfirmView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ConfirmView:_okClkHandler( sender, event )
    local GameNet = require("utils.GameNet")
    GameNet.send("C2s_buff_change", {change_name = self._name})
    
    local GameView = require("view.GameView")
    GameView.removePopUp(self)
end

--- 
-- 点击了取消
-- @function [parent=#ConfirmView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ConfirmView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self)
    
--    local UnderstandMartialView = require("view.role.UnderstandMartialView").instance
--    if UnderstandMartialView then
--    	UnderstandMartialView:getSubView():clearSelectedFrame()
--    end
    
end

---
-- 打开界面
-- @function [parent=#ConfirmView] openUi
-- @param self
-- @param #table pb
--
function ConfirmView:openUi(pb)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self:_init(pb)
end

---
-- 初始化界面
-- @function [parent=#ConfirmView] _init
-- @param self
-- @param #table pb
-- 
function ConfirmView:_init(pb)
	local UnderstandMartialSubView = require("view.role.UnderstandMartialSubView")
	UnderstandMartialSubView.handleAttr(pb.now_prop, true, true, false)
	UnderstandMartialSubView.handleAttr(pb.has_prop[1], true, true, false)
	
	self:changeFrame("iconSpr1", pb.now_prop["frame"])
	self:changeFrame("iconSpr2", pb.now_prop["frame"])
	
	self._name = pb.now_prop.prop_name
	
	local cor1, cor2 = "<c1>", "<c1>"
--	local ItemViewConst = require("view.const.ItemViewConst")
--	if pb.now_prop.prop_name == "Hp" or pb.now_prop.prop_name == "Ap" or pb.now_prop.prop_name == "Dp" or pb.now_prop.prop_name == "Speed" then
--		cor1 = ItemViewConst.BUFF_COLOR_TABLE[pb.now_prop.rate / 100 - 15]
--	else
--		cor1 = ItemViewConst.BUFF_COLOR_TABLE[pb.now_prop.rate / 100 - 10]
--	end
	
--	if pb.has_prop[1].prop_name == "Hp" or pb.has_prop[1].prop_name == "Ap" or pb.has_prop[1].prop_name == "Dp" or pb.has_prop[1].prop_name == "Speed" then
--		cor2 = ItemViewConst.BUFF_COLOR_TABLE[pb.has_prop[1].rate / 100 - 15]
--	else
--		cor2 = ItemViewConst.BUFF_COLOR_TABLE[pb.has_prop[1].rate / 100 - 10]
--	end
	
--	self["tipLab"]:setString(tr("您确定使用新的属性" .. pb.now_prop["attr"]) .. cor1.. "+" .. pb.now_prop.rate / 100 .. "%" .."</c>" .. tr("替换已有属性") .. 
--	tr("吗？"))
	self["attrLab1"]:setString(cor1 .. tr(pb.now_prop["attr"]) .. "+" .. pb.now_prop.rate / 100 .. "%" .."</c>")
	self["attrLab2"]:setString(cor2 .. tr(pb.has_prop[1]["attr"]) .. "+" .. pb.has_prop[1].rate / 100 .. "%" .."</c>")
	-- pb.has_prop["attr"] .. " +" .. pb.has_prop.rate / 100 .. "%" .. 
end

---
-- 退出界面时调用
-- @function [parent=#ConfirmView] onExit
-- @param self
-- 
function ConfirmView:onExit()
	instance = nil
	
	ConfirmView.super.onExit(self)
end