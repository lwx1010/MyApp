--- 
-- 帮助信息界面
-- @module view.help.HelpView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local pairs = pairs

local moduleName = "view.help.HelpView"
module(moduleName)


--- 
-- 类定义
-- @type HelpView
-- 
local HelpView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#HelpView] ctor
-- @param self
-- 
function HelpView:ctor()
	HelpView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#HelpView] _create
-- @param self
-- 
function HelpView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_help.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	self:showHelpInfo()
end

--- 
-- 点击了关闭
-- @function [parent=#HelpView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function HelpView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面时调用
-- @function [parent=#HelpView] onExit
-- @param self
-- 
function HelpView:onExit()
	instance = nil
	
	HelpView.super.onExit(self)
end

---
-- 打开界面调用
-- @function [parent=#HelpView] openUi
-- @param self
-- 
function HelpView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 显示帮助信息
-- @function [parent=#HelpView] showHelpInfo
-- @param self
-- 
function HelpView:showHelpInfo()
	local info = require("xls.HelpXls").data
	if not info then return end
	
	local itemBox = self["itemsVBox"]		--ui.VBox #VBox
	itemBox:setVSpace( 20 )
	itemBox:setSnapWidth(0)
	itemBox:setSnapHeight(200)
	
	local cell = require("view.help.InfoCell")
	for i = 1, #info do
		local item = info[i]
		if item then
			local view = cell.new()
			view:showItem( item )
			itemBox:addItem(view)
		end
	end
end