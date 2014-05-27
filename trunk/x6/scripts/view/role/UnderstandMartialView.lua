--- 
-- 提示框
-- @module view.role.UnderstandMartialView
-- 

local class = class
local require = require
local tr = tr
local printf = printf

local moduleName = "view.role.UnderstandMartialView"
module(moduleName)

--- 
-- 类定义
-- @type UnderstandMartialView
-- 
local UnderstandMartialView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 子view
-- @field [parent=#UnderstandMartialView] #CCLayer _subView
-- 
UnderstandMartialView._subView = nil

--- 
-- 构造函数
-- @function [parent=#UnderstandMartialView] ctor
-- @param self
-- 
function UnderstandMartialView:ctor()
	UnderstandMartialView.super.ctor(self)
	
	self:_create()
end

---
-- 创建实例
-- @function [parent=#view.role.UnderstandMartialView] new
-- @return #UnderstandMartialView 实例
-- 
function new()
	return UnderstandMartialView.new()
end

--- 
-- 创建
-- @function [parent=#UnderstandMartialView] _create
-- @param self
-- 
function UnderstandMartialView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_canwuwuxue.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	-- 参悟武学主view
	local UnderstandMartialSubView = require("view.role.UnderstandMartialSubView").new()
	self["backLayer"]:addChild(UnderstandMartialSubView)
	self["backLayer"]:setCascadeOpacityEnabled(false)
	self["backLayer"]:setOpacity(0)
	
	self._subView = UnderstandMartialSubView
	
	local RoleView = require("view.role.RoleView").instance
	if RoleView then
		RoleView:setBuffSubView(self._subView)
	end
end

---
-- 打开界面
-- @function [parent=#UnderstandMartialView] openUi
-- @param self
-- @param #table pb
-- 
function UnderstandMartialView:openUi(pb)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	if pb then
		self._subView:init(pb)
	else
		self:sendBuffRequest()
	end
end

---
-- 参悟返回处理
-- @function [parent=#UnderstandMartialView] handleUnderstandReturn
-- @param self
-- @param #table pb
--
function UnderstandMartialView:handleUnderstandReturn(pb)
	self._subView:handleUnderstandReturn(pb)
end

--- 
-- 点击了关闭
-- @function [parent=#UnderstandMartialView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function UnderstandMartialView:_closeClkHandler( sender, event )
	printf("enter close clk handler")
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 获取subView
-- @function [parent=#UnderstandMartialView] getSubView
-- @param self
-- @return #CCBView
-- 
function UnderstandMartialView:getSubView()
	return self._subView
end

---
-- 发送buff请求
-- @function [parent=#UnderstandMartialView] sendBuffRequest
-- @param self
--
function UnderstandMartialView:sendBuffRequest()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_buff_msg", {place_holder = 1})
	
	if self._subView then
		self._subView.isFromRoleView = false
	end
end

---
-- 处理buff信息
-- @function [parent=#UnderstandMartialView] handleBuffInfo
-- @param self
-- @param #talbe pb
--
function UnderstandMartialView:handleBuffInfo(pb)
	if not pb or not self._subView then return end
	self._subView:init(pb)
end

---
-- 退出界面时调用
-- @function [parent=#UnderstandMartialView] onExit
-- @param self
-- 
function UnderstandMartialView:onExit()
	instance = nil
	
	self._subView = nil
	
	local RoleView = require("view.role.RoleView").instance
	if RoleView then
		RoleView:setBuffSubTipView(nil)
	end
	
	UnderstandMartialView.super.onExit(self)
end