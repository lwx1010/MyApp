--- 
-- 玩法整合界面：结交玩法入口
-- @module view.qiyu.jiejiao.JieJiaoEnterView
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.qiyu.jiejiao.JieJiaoEnterView"
module(moduleName)

--- 
-- 类定义
-- @type JieJiaoEnterView
-- 
local JieJiaoEnterView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#JieJiaoEnterView] ctor
-- @param self
-- 
function JieJiaoEnterView:ctor()
	JieJiaoEnterView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#JieJiaoEnterView] _create
-- @param self
-- 
function JieJiaoEnterView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_jiejiao.ccbi", true)
	
	self:handleButtonEvent("jieJiaoCcb.aBtn", self._jieJiaoClkHandler)
end

---
-- 点击了结交
-- @function [parent=#JieJiaoEnterView] _jieJiaoClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JieJiaoEnterView:_jieJiaoClkHandler( sender, event )
--	printf("clk jiejiao")
--	local FloatNotify = require("view.notify.FloatNotify")
--	FloatNotify.show(tr("该功能暂未开放!"))

	local JieJiaoView = require("view.qiyu.jiejiao.JieJiaoView")
	JieJiaoView.createInstance():openUi()
end

---
-- 打开界面调用
-- @function [parent=#JieJiaoEnterView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function JieJiaoEnterView:openUi( info )
	if not info then return end
	
--	self:setVisible(true)
end

---
-- 关闭界面
-- @function [parent=#JieJiaoEnterView] closeUi
-- @param self
-- 
function JieJiaoEnterView:closeUi()
--	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#JieJiaoEnterView] onExit
-- @param self
-- 
function JieJiaoEnterView:onExit()
	
	instance = nil
	
	self.super.onExit(self)
	
end