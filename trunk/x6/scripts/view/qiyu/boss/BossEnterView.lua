--- 
-- 玩法整合界面：boss入口
-- @module view.qiyu.boss.BossEnterView
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.qiyu.boss.BossEnterView"
module(moduleName)

--- 
-- 类定义
-- @type BossEnterView
-- 
local BossEnterView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 按钮是否可用
-- @function [parent = #view.qiyu.boss.BossEnterView] _isButtonEnable
-- 
local _isButtonEnable = false

--- 
-- 构造函数
-- @function [parent=#BossEnterView] ctor
-- @param self
-- 
function BossEnterView:ctor()
	BossEnterView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BossEnterView] _create
-- @param self
-- 
function BossEnterView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_boss.ccbi", true)
	
	self:handleButtonEvent("goCcb.aBtn", self._goClkHandler)
	self["goCcb.aBtn"]:setEnabled(_isButtonEnable)
end

---
-- 设置前往BTN可不可用
-- @function [parent = #view.qiyi.boss.BossEnterView] setGoButtonEnable
-- @param #bool enable
-- 
function setGoButtonEnable(enable)
	_isButtonEnable = enable
	if require("view.qiyu.boss.BossEnterView").instance then
		require("view.qiyu.boss.BossEnterView").instance["goCcb.aBtn"]:setEnabled(enable)
	end
end

---
-- 点击了前往
-- @function [parent=#BossEnterView] _goClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BossEnterView:_goClkHandler( sender, event )
	local bossView = require("view.boss.BossMainView").instance
	if bossView == nil then
		bossView = require("view.boss.BossMainView").createInstance()
	end
	local gameView = require("view.GameView")
	gameView.addPopUp(bossView, true)
end

---
-- 打开界面调用
-- @function [parent=#BossEnterView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function BossEnterView:openUi( info )
	if not info then return end
	
	self:setVisible(true)
	
end

---
-- 关闭界面
-- @function [parent=#BossEnterView] closeUi
-- @param self
-- 
function BossEnterView:closeUi()
	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#BossEnterView] onExit
-- @param self
-- 
function BossEnterView:onExit()
	instance = nil
	
	BossEnterView.super.onExit(self)
end